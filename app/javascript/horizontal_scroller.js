document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("steps-container");
  const btnLeft = document.getElementById("scroll-left");
  const btnRight = document.getElementById("scroll-right");
  const steps = document.querySelectorAll("[data-step]");
  const scrollAmount = 260;
  let currentStep = 1;
  let autoPlayInterval = null;
  const AUTO_PLAY_DELAY = 2000; // milliseconds (3 seconds per step)

  // Highlight active step + animate arrow line
  function highlightStep(stepNum) {
    steps.forEach(step => {
      const num = parseInt(step.dataset.step);
      const flow = step.querySelector(".animated-flow");
      step.classList.toggle("active-step", num === stepNum);

      if (flow && num === stepNum) {
        flow.classList.remove("animate-flow");
        void flow.offsetWidth; // Restart CSS animation
        flow.classList.add("animate-flow");
      }
    });
  }

  // Scroll smoothly to the given step
  function scrollToStep(stepNum) {
    const stepElement = document.querySelector(`[data-step="${stepNum}"]`);
    if (stepElement) {
      const leftPos = stepElement.offsetLeft - container.offsetLeft - 40;
      container.scrollTo({ left: leftPos, behavior: "smooth" });
      highlightStep(stepNum);
    }
  }

  // Manual controls
  btnRight.addEventListener("click", () => {
    if (currentStep < steps.length) currentStep++;
    else currentStep = 1;
    scrollToStep(currentStep);
    restartAutoPlay();
  });

  btnLeft.addEventListener("click", () => {
    if (currentStep > 1) currentStep--;
    else currentStep = steps.length;
    scrollToStep(currentStep);
    restartAutoPlay();
  });

  // Auto-play function
  function startAutoPlay() {
    autoPlayInterval = setInterval(() => {
      currentStep = currentStep < steps.length ? currentStep + 1 : 1;
      scrollToStep(currentStep);
    }, AUTO_PLAY_DELAY);
  }

  // Restart autoplay after manual action
  function restartAutoPlay() {
    clearInterval(autoPlayInterval);
    startAutoPlay();
  }

  // Pause autoplay when hovering or focusing
  container.addEventListener("mouseenter", () => clearInterval(autoPlayInterval));
  container.addEventListener("mouseleave", startAutoPlay);
  btnLeft.addEventListener("mouseenter", () => clearInterval(autoPlayInterval));
  btnRight.addEventListener("mouseenter", () => clearInterval(autoPlayInterval));

  // Initialize
  highlightStep(currentStep);
  startAutoPlay();
});
