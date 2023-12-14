$(document).ready(function () {
    function handleImageChange(inputClass, imageClass) {
        $(inputClass).change(function () {
            var curElement = $(imageClass);
            console.log(curElement);
            var reader = new FileReader();

            reader.onload = function (e) {
                // get loaded data and render thumbnail.
                curElement.attr('src', e.target.result);
            };

            // read the image file as a data URL.
            reader.readAsDataURL(this.files[0]);
        });
    }

    handleImageChange('.file-input1', '.image1');
    handleImageChange('.file-input2', '.image2');



    /* **** Add Remove Class **** */
    $(".toggle-swich").on("click", function () {
        $("body").toggleClass("show-dark");
    });
});
