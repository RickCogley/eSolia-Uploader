+++
date = "2018-11-30T07:14:51+09:00"
draft = "false"
tags = ["eSolia","Uploader","Uppy","Transloadit","Hookdoo","top","home"]
title = "eSolia Uploader"
+++

This app makes it easy to get a URL for a screenshot to be used in a markdown document.

To use, prepare your screenshots on your local PC or Mac, using _English filenames_, then drag them to the area below. After dragging, you can click "Edit" to optionally set the name or description (doesn't do anything yet). Once you're ready, click Upload. The uploader transfers them to a service for processing (renaming, resizing), after which they are stored in Amazon AWS S3. In a few seconds they will be processed, and their URLs will be available in the PROdb <a href="https://pro.dbflex.net/secure/db/15331/overview.aspx?t=510378" class="link dim dark-pink" target="_blank"><b>Upload Links</b></a> table.

<div class="DashboardContainer mb4"></div>
<div id="uppy-transloadit-result"></div>


### Notes as of 20181127: 

* It's highly likely there are bugs. Let Rick know. 
  * PDFs get stored in S3, but the PDF URL is not copied to PROdb.
  * Clicking "Edit" and filling the fields before uploading does nothing, at this time. 
* Your original file, and resized files of 800px and 150px in width will be stored. Ask if other sizes are needed. 
* Files are renamed to include "eSolia-" as a prefix, and a unique identifier and the width before the extension. 
* The app returns the S3 file links under the "Dashboard" so you can use those, or, refer to the ones listed in PROdb. 
