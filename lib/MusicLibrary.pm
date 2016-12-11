package MusicLibrary;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw(schema resultset rset);
use DDP;

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
    if (!session('user') && request->dispatch_path !~ m{^/login}) {
        forward '/login', { requested_path => request->dispatch_path };
	}
};

######################### albums ################################

get '/albums/new' => sub { 
	template 'new_album';
};

get '/albums/edit' => sub { 
	template 'edit_album';
};

post '/albums' => sub { 
	my $album = param('album');
	my $year = param('year');
	my $group = param('group');
	my $user = session('user')
	
	my $album = schema->resultset('Album')->create({ album => $album, year => $year, group => $group, user_id => $user });
	redirect '/albums/'.$album->id;
};

get '/albums/:album_id' => sub {
    my $album_id = param 'album_id';
    my $album = schema->resultset('Album')->find($album_id);
    template album => { album => $album };
};

put '/albums/:album_id' => sub {
    my $album_id = param 'album_id';
    
    if (session('user') == $album_id) {
		my $album = param('album');
		my $year = param('year');
		my $group = param('group');
	
		my $album = schema->resultset('Album')->find($album_id)->update({ album => $album, year => $year, group => $group });
		template album => { album => $album };
    } else {
    	template album => { album => $album, err => "У вас нет прав" };
    }
};

true;
