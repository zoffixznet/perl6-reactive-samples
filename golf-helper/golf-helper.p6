use GTK::Simple;

my $app = GTK::Simple::App.new(title => 'Code Golf Assistant!');

$app.set_content(GTK::Simple::VBox.new(
    my $source  = GTK::Simple::TextView.new(),
    my $chars   = GTK::Simple::Label.new(text => 'Characters: 0'),
    my $elapsed = GTK::Simple::Label.new(),
    my $results = GTK::Simple::TextView.new(),
));

$source.changed.tap({
    $chars.text = "Characters: $source.text.chars()";
});

Supply.interval(1).schedule_on(
    GTK::Simple::Scheduler
).tap(-> $secs {
    $elapsed.text = "Elapsed: $secs seconds";
});

$source.changed.stable(1).start({
    (try EVAL .text) // $!.message
}).migrate.schedule_on(GTK::Simple::Scheduler).tap(
    { $results.text = $_ }
);

$app.run();

