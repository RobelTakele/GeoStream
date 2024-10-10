// src/app/shinyApp/page.js
export default function ShinyAppPage() {
  return (
<div>
  <div className="container mt-5">
    <iframe
      src="https://robeltakele.shinyapps.io/aquabehergui/"
      width="100%"  // Adjusted to 100% width
      height="600px"
      style={{ border: "none" }}
      title="Shiny App"
    ></iframe>
  </div>
</div>

  );
}
