$(function() {
	$("ol.slideshow").each(function(index) {
		prepareSlideshow(this);
	});
});

function prepareSlideshow(slideshow)
{
	var slideshowDelay = getNumber("interval", 1) * 1000;
	var animationDuration = 500;
	var animationSteps = 20;
	var current = null;

    window.addEventListener("resize", onWindowResize);
    advance();

    function getData(name)
    {
        return slideshow.getAttribute("data-" + name);
    }

    function getNumber(name, defaultValue)
    {
        var data = getData(name);

        return data == defaultValue ? defaultValue : +data;
    }

	function onWindowResize()
	{
		var slide = slideshow.firstElementChild;

		while (slide) {
			var child = slide.firstElementChild;

			while (child) {
				if (child.tagName.toLowerCase() == "img" && child._nativeWidth && child._nativeHeight) {
					scaleImage(child);
				}
				child = child.nextElementChild;
			}
			slide = slide.nextElementSibling;
		}
	}

    function scaleImage(img)
	{
		var cw = slideshow.clientWidth;
		var ch = slideshow.clientHeight;
		var w = img._nativeWidth;
		var h = img._nativeHeight;
		var sx = cw / w;
		var sy = ch / h;
		var scale = Math.max(sx, sy);
		var focus_x = (img._focus_x != undefined) ? img._focus_x : 0.5;
		var focus_y = (img._focus_y != undefined) ? img._focus_y : 0.5;
		
		img.style.position = "absolute";
        img.style.width = w * scale + "px";
        img.style.height = h * scale + "px";
		img.style.top = (ch - img.height) * focus_y + "px";
		img.style.left = (cw - img.width) * focus_x + "px";
//        console.log(w + ", " + h + ", " + cw + ", " + ch + " * " + scale + " => " + img.style.width + ", " + img.style.height);
	}
	
	function prepareSlide(slide, then)
	{
		var imageSrc = getData("image-src");

		if (imageSrc) {
			var img = new Image();
			
			img.addEventListener("load", function() {
				img._nativeWidth = img.width;
				img._nativeHeight = img.height;
				img._focus_x = getNumber("image-focus-x");
				img._focus_y = getNumber("image-focus-y");
				slide.insertBefore(img, slide.firstChild);
				slide.removeAttribute("data-image-src");
				scaleImage(img);
				then();
			});
			img.src = imageSrc;
		} else {
			then();
		}

        function getData(name)
        {
            return slide.getAttribute("data-" + name);
        }
        function getNumber(name)
        {
            var data = getData(name);

            return data == undefined ? undefined : +data;
        }
	}
	
	function showSlide(slide)
	{
		var step = 0;
        var slideClass = slide.getAttribute("data-class");

		slide.style.opacity = 0;
		slide.style.visibility = "visible";
		slide.style.zIndex = 1;
		if (current)
			current.style.zIndex = 0;
        if (slideClass) {
            slideshow.setAttribute("data-slide-class", slideClass);
        } else {
            slideshow.removeAttribute("data-slide-class");
        }

        if (current) {
            animate();
        } else {
            slide.style.opacity = 1;
            current = slide;
            setTimeout(advance, slideshowDelay);
        }

		function animate()
		{
			var time = step / animationSteps;
			
			slide.style.opacity = time;
			
			if (step < animationSteps) {
				step++;
				setTimeout(animate, animationDuration / animationSteps);
			} else {
				current.style.visibility = "hidden";
				current = slide;
				setTimeout(advance, slideshowDelay);
			}
		}
	}
	
	function advance()
	{
		var next = null;
		
		if (current) {
			next = current.nextElementSibling;
		}
		if (!next) {
			next = slideshow.firstElementChild;
		}
		if (next) {
			prepareSlide(next, function() { showSlide(next); });
		}
	}
}

