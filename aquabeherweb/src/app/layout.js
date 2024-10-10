// src/app/layout.js
import "bootstrap/dist/css/bootstrap.min.css"; // Import Bootstrap CSS
import "./AqBlandingPage.css"; // Custom global styles

export const metadata = {
  title: "AquaBEHERweb",
  description: "Web app for AquaBEHER",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head />
      <body className="d-flex flex-column min-vh-100">
        {/* Navigation Bar */}
        <nav className="navbar navbar-expand-lg" style={{ backgroundColor: "#2d8c9c" }}>
          <div className="container-fluid">
            {/* Logo and Title */}
            <a className="navbar-brand d-flex align-items-center" href="/">
              <img
                src="/assets/img/AquaBEHERlogo.png"
                alt="AquaBEHER Logo"
                style={{ height: "60px", marginRight: "15px" }}
              />
              <span style={{ color: "white", fontSize: "28px", fontWeight: "bold" }}>AquaBEHERweb</span>
            </a>

            {/* Navbar Links */}
            <div className="collapse navbar-collapse" id="navbarNav">
              <ul className="navbar-nav">
                <li className="nav-item">
                  <a className="nav-link" href="/" style={{ color: "white", fontSize: "20px" }}>Home</a>
                </li>
                <li className="nav-item">
                  <a className="nav-link" href="/map" style={{ color: "white", fontSize: "20px" }}>Map</a>
                </li>
                <li className="nav-item">
                  <a className="nav-link" href="/shinyApp" style={{ color: "white", fontSize: "20px" }}>ShinyApp</a>
                </li>
              </ul>
            </div>

            {/* Navbar Toggler */}
            <button
              className="navbar-toggler"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target="#navbarNav"
              aria-controls="navbarNav"
              aria-expanded="false"
              aria-label="Toggle navigation"
            >
              <span className="navbar-toggler-icon"></span>
            </button>
          </div>
        </nav>

        {/* Main content */}
        <div className="flex-grow-1">
          {children}
        </div>

        {/* Footer */}
        <footer className="footer mt-auto py-3">
          <div className="container d-flex align-items-center">
            {/* Institution Logo */}
            <img
              src="/assets/img/IPSlogo.png"
              alt="Institution Logo"
              style={{ height: "80px", marginRight: "10px" }}
            />
            {/* Institution Details */}
            <div className="footer-details">
              <p style={{ margin: 0, fontWeight: "bold", fontSize: "18px" }}>Institute of Plant Sciences</p>
              <p style={{ margin: 0 }}>Sant'Anna School of Advanced Studies</p>
              <p style={{ margin: 0 }}>Piazza Martiri della Libertà, 33, 56127 Pisa (Italy)</p>
              <p style={{ margin: 0 }}>Contact: +39 050 883111</p>
              <p style={{ margin: 0 }}>
                Email: <a href="mailto:protocollo@sssup.legalmailpa.it">protocollo@sssup.legalmailpa.it</a>
              </p>
            </div>
          </div>
        </footer>

        {/* Bootstrap JS */}
        <script
          src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-ENjdO4Dr2bkBIFxQpeo+7FvW5z5yib1D2eR50Zmn+3GkR5T6c1dTRKfF5QGgzaf8"
          crossOrigin="anonymous"
        ></script>
      </body>
    </html>
  );
}
