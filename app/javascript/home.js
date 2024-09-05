
import Splide from '@splidejs/splide';

function numberWithSpaces(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

let inputBuyMurtiCount = document.getElementById("buy-murti-count");
  inputBuyMurtiCount.addEventListener("change", function() {
    if (this.value > 29) {
      this.value = 29;
    }
    else if (this.value < 1) {
      this.value = 1;
    }
    let countText = document.getElementById("buy-murti-count-text");
    countText.innerHTML = numberWithSpaces(`${(this.value * 10800)}`) + " р.";
});

let statusModal = document.getElementById("status-modal");
let button = document.getElementById("operation-button");
if (statusModal) {
  button.click();
}

document.addEventListener("turbo:load", (_event) => {
  let inputBuyMurtiCount = document.getElementById("buy-murti-count");
  inputBuyMurtiCount.addEventListener("change", function() {
    if (this.value > 29) {
      this.value = 29;
    }
    else if (this.value < 1) {
      this.value = 1;
    }
    let countText = document.getElementById("buy-murti-count-text");
    countText.innerHTML = numberWithSpaces(`${(this.value * 10800)}`) + " р.";
});


  new Splide(".splide-wide", {
    perPage: 5,
    gap: "2rem",
    fixedWidth: "14rem"
  }).mount();

  Array.from(document.querySelectorAll(".slide-image")).forEach((image, index) => {
    image.addEventListener("click", function() {
      // this.style.visibility = 'hidden';
      // this.style.display = "none";
      // document.getElementById(`slide-video-${index}`).click();
    });
  });


  Array.from(document.querySelectorAll(".gallery-item")).forEach((galleryImage, _index) => {
    galleryImage.addEventListener("click", function() {
      let largeImageSrc = this.getAttribute("large-image-src");
      document.getElementById("galleryLargeImage").setAttribute("src", largeImageSrc);
    });
  });

  Array.from(document.querySelectorAll(".review-slide-button")).forEach((slideButton, _index) => {
    slideButton.addEventListener("click", function() {
      const direction = this.dataset.direction;
      let offset = direction == "left" ? -1 : 1;
      showSlide(offset);
    });
  });

  var slideIndex = 0;
  showSlide(0);

  function showSlide(offset) {
    var slideItems = document.querySelectorAll(".review-item-content");

    slideIndex += offset;
    if (slideIndex > (slideItems.length - 1)) {
      slideIndex = 0;
    }
    else if (slideIndex < 0) {
      slideIndex = slideItems.length - 1;
    }
    for (var i = 0; i < slideItems.length; i++) {
      slideItems[i].style.display = "none";
    }
    slideItems[slideIndex].style.display = "flex";
  }
});
