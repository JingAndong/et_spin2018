var root = [].slice.call(document.getElementsByTagName("script")).pop().src.split("/").slice(0,-1).join("/")+"/";

document.write(
  '<script src="'+root+'bootstrap/js/jquery.min.js"></script>'+
  '<script src="'+root+'bootstrap/js/bootstrap.min.js"></script>'+
  '<meta name="viewport" content="width=device-width, initial-scale=1">'+
  '<!-- Latest compiled and minified CSS -->'+
  '<link href="'+root+'bootstrap/css/bootstrap.min.css" rel="stylesheet">'+
  '<link href="'+root+'bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">'+
 // '<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet" type="text/css">'+
  '<link href="'+root+'css/etk.css" rel="stylesheet" type="text/css">'+
  ''
  );


