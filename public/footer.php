    <div class="page">
        <div class="nav-bar bg-color-white">
            <div class="nav-bar-inner padding10">
                <span class="element">
                    &copy; 2010-2013 <a href="mailto:info@indiegamegarden.com">Indiegame Garden</a> and others.
                </span>
            </div>
        </div>
    </div>

    <?php include("counter.php");?>

    <script type="text/javascript" src="js/assets/github.info.js"></script>
    <script type="text/javascript" src="js/assets/google-analytics.js"></script>
    <script type="text/javascript" src="js/google-code-prettify/prettify.js"></script>
    <script src="js/sharrre/jquery.sharrre-1.3.4.min.js"></script>

    <script>
        $('#shareme').sharrre({
            share: {
                googlePlus: true
                ,facebook: true
                ,twitter: true
                ,delicious: true
            },
            urlCurl: "js/sharrre/sharrre.php",
            buttons: {
                googlePlus: {size: 'tall'},
                facebook: {layout: 'box_count'},
                twitter: {count: 'vertical'},
                delicious: {size: 'tall'}
            },
            hover: function(api, options){
                $(api.element).find('.buttons').show();
            }
        });
    </script>

    </body>
</html>