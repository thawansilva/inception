document.getElementById("year").textContent = new Date().getFullYear();

const button = document.getElementById("theme-btn");

button.addEventListener("click", () => {
    document.body.classList.toggle("light");

    button.textContent =
        document.body.classList.contains("light")
        ? "☀️"
        : "🌙";
});
