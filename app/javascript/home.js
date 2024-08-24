
import Splide from '@splidejs/splide';

document.addEventListener("DOMContentLoaded", (event) => {
  new Splide(".splide-wide", {
    perPage: 4,
    gap: "2rem",
    breakpoints: {
      991: {
        perPage: 1,
      },
    }
  }).mount();

  let image = document.querySelector('.video-image');
  // image.addEventListener("click", function() {
  //  this.style.visibility = 'hidden';
  //  document.querySelector(".description-video-frame").click();
  // });
});