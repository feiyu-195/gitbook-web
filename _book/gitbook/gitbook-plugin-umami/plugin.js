require(["gitbook"], function(gitbook) {
    gitbook.events.bind("start", function(e, config) {
        var cfg = config['umami'];

        var script = document.createElement("script");
        script.defer = true;
        script.src = cfg.url;
        script.setAttribute("data-website-id", cfg.website-id);

        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(script, s);
    });
});
