$(document).on('turbolinks:load', function(){
  $('.profile_photos.edit, .cover_photos.edit').ready(function(){
    $('#fileInput').on('change', function () {
      if (typeof (FileReader) != 'undefined') {
        var file = this.files[0]
        var fileSize = file.size

        if(fileSize > 1024 * 1024 * 10){
          $(this).val('');
          alert('File size cannot exceed 10MB');
        }else{
          var _URL = window.URL || window.webkitURL;
          img = new Image();

          // minimum image dimensions
          var minWidth, minHeight, wideAspect;
          if($(this).data('min-width')){
            minWidth = parseInt($(this).data('min-width'));
          }else{
            console.log('WARNING: Minimum image width not defined');
          }
          if($(this).data('min-height')){
            minHeight = parseInt($(this).data('min-height'));
          }else{
            console.log('WARNING: Minimum image height not defined');
          }
          if($(this).data('wide-aspect')){
            wideAspect = true;
          }

          img.onload = function () {
            var aspect = this.height / this.width;

            if(this.height < minHeight){
              $(this).val('');
              alert('Image height must be greater than '+ minHeight + 'px');
            }else if(this.width < minWidth){
              $(this).val('');
              alert('Image width must be greater than ' + minWidth + 'px');
            }else if(!wideAspect && (aspect > 2 || aspect < 0.5)){
              $(this).val('');
              alert('Invalid aspect ratio on your image. Make sure it is either 4:3, 3:2 or 16:9');
            }else{
              var image_holder = $('#image-holder');
              image_holder.empty();

              var reader = new FileReader();
              reader.onload = function (e) {
                  $('<img />', {
                      'src': e.target.result,
                      'class': 'thumb-image'
                  }).appendTo(image_holder);

              }
              image_holder.show();
              reader.readAsDataURL(file);
            }
          };
          img.src = _URL.createObjectURL(file);
        }
      }
    });

    $.fn.form.settings.rules.maxFileSize = function(value, element, param) {
      var fileSize = $('#fileInput')[0].files[0].size
      return fileSize < 1024 * 1024
    };
  });
});