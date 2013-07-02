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

    $r->get('/report')->to(controller => 'report', action => 'report');
    $r->post('/show_report_order')->to(controller => 'report', action => 'show_report');
    $r->post('/show_report_customer')->to(controller => 'report', action => 'show_report');
    $r->post('/show_report_date')->to(controller => 'report', action => 'show_report');

}

1;
