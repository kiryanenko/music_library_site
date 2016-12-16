package MusicLibrary;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw(schema resultset rset);
use DDP;
use utf8;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

our $VERSION = '0.1';

get '/' => sub {
	template 'index';
};

######################### users ################################

get '/users/new' => sub { 
	template 'registration';
};

get '/users' => sub { 
	my @users = schema->resultset('User')->all;
	template 'users' => { users => \@users };
};

post '/users' => sub { 
	my $login = param('login');
	my $password = param('password');
	my $confirm_password = param('confirm_password');
	
	if ($password eq $confirm_password) {
		my $user = schema->resultset('User')->create({ login => $login, password => $password });
		redirect '/login';
	} else {
		template 'registration' => { err => 'Повторный пароль не совпал!' };
	}
};

get '/users/:user_id' => sub {
    my $user_id = param 'user_id';
    my $user = schema->resultset('User')->find($user_id);
    template user_profile => { user => $user };
};

######################### session ################################

get '/login' => sub { 
	template 'login';
};

post '/new_session' => sub {
	my $login = param('login');
	my $password = param('password');
	
	if ( my $user = schema->resultset('User')->find({ login => $login, password => $password }) ) {
		session 'user' => $user->id;
		redirect '/';
	} else {
		template 'login' => { err => 'Неверный логин или пароль!' };
	}
};

get '/logout' => sub {
    session->destroy;
    redirect '/';
};

hook before => sub {
    if (!session('user') && request->path !~ m{^/login}) {
        template '/login';
	}
};

######################### albums ################################

get '/albums/new' => sub { 
	template 'new_album';
};

get '/albums/:album_id/edit' => sub { 
 	my $album_id = param 'album_id';
    my $album = schema->resultset('Album')->find($album_id);
	template 'edit_album' => { album => $album };
};

post '/albums' => sub { 
	my $title = param('album');
	my $year = param('year');
	my $band = param('band');
	my $user = session('user');
	
	my $album = schema->resultset('Album')->create({ album => $title, year => $year, band => $band, user_id => $user });
	redirect '/albums/'.$album->id;
};

get '/albums/:album_id' => sub {
    my $album_id = param 'album_id';
    my $album = schema->resultset('Album')->find($album_id);
    template album => { album => $album };
};

post '/albums/:album_id' => sub {
    my $album_id = param 'album_id';
    my $album = schema->resultset('Album')->find($album_id);
    
    if (session('user') == $album->user->id) {
		my $title = param('album');
		my $year = param('year');
		my $band = param('band');
	
		$album->update({ album => $title, year => $year, band => $band });
		template album => { album => $album };
    } else {
    	template album => { album => $album, err => "У вас нет прав" };
    }
};

######################### tracks ################################

get '/tracks/new' => sub { 
	my @albums = schema->resultset('User')->find(session('user'))->albums;
	template 'new_track' => { albums => \@albums };
};

get '/tracks/:track_id/edit' => sub { 
	my $track_id = param 'track_id';
    my $track = schema->resultset('Track')->find($track_id);
    my @albums = schema->resultset('User')->find(session('user'))->albums;
	template 'edit_track' => { track => $track, albums => \@albums };
};

post '/tracks' => sub { 
	my $title = param('track');
	my $image = param('image');
	my $format = param('format');
	my $album = param('album');
	
	if (my $image_file = request->upload('image_file')) {
		my $dir = path(config->{appdir}, 'public/images');
		mkdir $dir if not -e $dir;
	 
	 	my $name = time.$image_file->basename;
		my $path = path($dir, $name);
		if (-e $path) {
		    return "'$path' already exists";
		}
		$image_file->link_to($path);
		$image = "/images/$name";
    }
	
	my $track = schema->resultset('Track')->create({ track => $title, album_id => $album, image => $image, 'format' => $format });
	redirect '/tracks/'.$track->id;
};

get '/tracks/:track_id' => sub {
    my $track_id = param 'track_id';
    my $track = schema->resultset('Track')->find($track_id);
    template track => { track => $track };
};

post '/tracks/:track_id' => sub {
    my $track_id = param 'track_id';
    my $track = schema->resultset('Track')->find($track_id);
    
    if (session('user') == $track->album->user->id) {
		my $title = param('track');
		my $image = param('image');
		my $format = param('format');
		my $album = param('album');
		
		if (my $image_file = request->upload('image_file')) {
			my $dir = path(config->{appdir}, 'public/images');
			mkdir $dir if not -e $dir;
		 
		 	my $name = time.$image_file->basename;
			my $path = path($dir, $name);
			if (-e $path) {
				return "'$path' already exists";
			}
			$image_file->link_to($path);
			$image = "/images/$name";
		}
	
		$track->update({ track => $title, album_id => $album, image => $image, 'format' => $format });
		template track => { track => $track };
    } else {
    	template track => { track => $track, err => "У вас нет прав!" };
    }
};

######################### parser ################################

get '/parser' => sub { 
	template 'parser';
};

post '/parse' => sub { 
	my $user_id = session('user');
	p my $table = param('table');
	
	my $user = schema->resultset('User')->find($user_id);
	my %albums;
	my $flag = 1;
	
	$flag = '' unless $table =~ s!^/.+$!!m;
	
	while ( $flag ) {
		unless ( $table =~ s/^\|\s+(.+?) \|\s+(\d{4}) \|\s+(.+?) \|\s+(.+?) \|\s+(.+?)\s\|//m ) {
			$flag = '';
			last;
		}
		
		$albums{$3} = {
			band => $1,
			year => $2,
			user => $user,
			tracks => []
		} unless exists $albums{$3}{tracks};
		push $albums{$3}{tracks}, { track => $4, 'format' => $5 };
		
		unless ( $table =~ s/^\|.+\+.+\+.+\+.+\+.+\|//m ) {
			$flag = '' unless $table =~ s!^\\.+/!!m;
			last;
		}
	}
	
	if ($flag) {
		while( my ($key, $value) = each %albums ) {
			my $album = $user->albums->find({ album => $key });
			if ($album) {
				$album->update({ band => $value->{band}, year => $value->{year} });
				my $tracks = $value->{tracks};
				for (@$tracks) {
					my $track = $album->tracks->search({ track => $$_{track} })->first;
					if ($track) {
						$track->update( $_ );
					} else {
						$$_{album} = $album;
						p $_;
						schema->resultset('Track')->create( $_ );
					}
				}
			} else {
				$value->{album} = $key;
				schema->resultset('Album')->create( $value );
			}
		}
		redirect "/users/$user_id";
	} else {
		template parser => { table => param('table'), err => "Невалидная таблица!" };
	}
};

true;
