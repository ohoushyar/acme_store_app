package AcmeStoreApp::Upload;
use Mojo::Base 'Mojolicious::Controller';
use AcmeStore::PosDataCSVParser;

# This action will render a template
sub do_upload {
    my $self = shift;
    my $logger = $self->app->log;

    # Check file size
    return $self->render(text => 'File is too big.', status => 200)
        if $self->req->is_limit_exceeded;

    # Process uploaded file
    return $self->redirect('/upload')
        unless my $upload_file = $self->param('csvfile');
    my $name = $upload_file->filename;

    my $path = '/tmp/acme_store_app';
    my $full_path = "$path/$name.$$.".time;
    unless (-d $path) {
        $logger->debug("Creating the tmp folder [$path]");
        system("mkdir -p $path");
    }
    $logger->debug("Moving file to [$full_path]");
    $upload_file->move_to("$full_path");

    $logger->debug("Processing file ...");

    my $csv_parsert = AcmeStore::PosDataCSVParser->new(fullpath_filename => $full_path);
    eval {
        $csv_parsert->save;
    };
    $logger->debug("Unable to save uploaded file [$full_path]; ERROR [$@]") if $@;

    $logger->debug("... Processing file is done");

    $self->render(text => "Thanks for uploading. File processed successfully.");
}

1;
