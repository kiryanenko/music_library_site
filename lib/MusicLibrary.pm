package MusicLibrary;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw(schema resultset rset);
use DDP;

our $VERSION = '0.1';

get '/' => sub {
	if (!session('user')) {
		redirect '/login';
	}
	
    template 'index';
};

get '/login' => sub { 
	template 'login';
};

get '/users/new' => sub { 
	template 'registration';
};

post '/users' => sub { 
	my $login = param('login');
	my $password = param('password');
	my $confirm_password = param('confirm_password');
	
	if ($password eq $confirm_password) {
		my $user = schema->resultset('User')->create({ login => $login, password => $password });
		redirect '/login';
	} else {
		template 'registration' => {
            err => 'Повторный пароль не совпал!'
        };
	}
};

get '/users/:user_id' => sub {
        my $user_id = param 'user_id';
        # all of the following are equivalent:
        my $user = schema->resultset('User')->find($user_id);

        template user_profile => {
            login => $user->login
        };
    };

post '/new_session' => sub {
	my $login = param('login');
	my $password = param('password');
	
	if ( my $user = schema->resultset('User')->find({ login => $login, password => $password }) ) {
		session(user => $user->id);
		redirect '/';
	} else {
		template 'login' => {
            err => 'Неверный логин или пароль!'
        };
	}
};

true;
