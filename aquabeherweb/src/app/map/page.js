// src/app/map/page.js
export default function MapPage() {
  return (
    <div className="container mt-5">

      <iframe
        src="/maps/leafletMap.html"
        width="100%"
        height="600px"
        style={{ border: "none" }}
        title="Leaflet Map"
      ></iframe>
    </div>
  );
}
