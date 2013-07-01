package AcmeStoreApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  # $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to(controller => 'main', action => 'welcome');

  $r->get('/upload')->to(controller => 'upload', action => 'upload');
  $r->post('/do_upload')->to(controller => 'upload', action => 'do_upload');
}

1;
