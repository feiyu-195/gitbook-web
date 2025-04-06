require(["gitbook"], function(gitbook) {
    gitbook.events.bind("start", function(e, config) {
        var cfg = config['umami'];

        var site = document.createElement("script");
        site.defer = true;
        site.src = cfg.url;
        site.setAttribute("data-website-id", cfg.website-id);

        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(script, s);
    });
});
