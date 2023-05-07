<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Employee CRUD</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">

    %{--    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">--}%
    <g:layoutHead/>
    <r:layoutResources/>
</head>

<body style="margin: auto">
%{--<div id="grailsLogo" role="banner"><a href="http://grails.org"><img--}%
%{--        src="${resource(dir: 'images', file: 'grails_logo.png')}" alt="Grails"/></a></div>--}%

<nav class="navbar navbar-expand-lg navbar-dark bg-success text-primary">
    <div class="container-fluid">
        <a class="navbar-brand text-white" href="#">Employee CRUD</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
%{--        <div class="collapse navbar-collapse" id="navbarNav">--}%
%{--            <ul class="navbar-nav">--}%
%{--                <li class="nav-item">--}%
%{--                    <a class="nav-link" href="#">Home</a>--}%
%{--                </li>--}%
%{--                <li class="nav-item">--}%
%{--                    <a class="nav-link" href="#">Employees</a>--}%
%{--                </li>--}%
%{--                <li class="nav-item">--}%
%{--                    <a class="nav-link" href="#">Create Employee</a>--}%
%{--                </li>--}%
%{--            </ul>--}%
%{--        </div>--}%
    </div>
</nav>

<g:layoutBody/>
<div class="footer bg-success" role="contentinfo"></div>

<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
<g:javascript library="application"/>
<r:layoutResources/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"
        integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
