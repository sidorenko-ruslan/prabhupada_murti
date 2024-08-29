
import Splide from '@splidejs/splide';

document.addEventListener("DOMContentLoaded", (event) => {
  let statusModal = document.getElementById("status-modal");
  let button = document.getElementById("operation-button");
  if (statusModal) {
    button.click();
  }

  new Splide(".splide-wide", {
    perPage: 4,
    gap: "2rem",
    breakpoints: {
      991: {
        perPage: 1,
      },
    }
  }).mount();

  Array.from(document.querySelectorAll(".slide-image")).forEach((image, index) => {
    image.addEventListener("click", function() {
      this.style.visibility = 'hidden';
      this.style.display = "none";
      document.getElementById(`slide-video-${index}`).click();
    });
  });


  Array.from(document.querySelectorAll(".gallery-item")).forEach((galleryImage, index) => {
    galleryImage.addEventListener("click", function() {
      let largeImageSrc = this.getAttribute("large-image-src");
      document.getElementById("galleryLargeImage").setAttribute("src", largeImageSrc);
    });
  });
});
