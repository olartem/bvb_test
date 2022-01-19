window.initMap = function (lat, lng, markers) {
  var myCoords = new google.maps.LatLng(lat, lng);
  var mapOptions = {
  center: myCoords,
  zoom: 6
  };
  var map = new google.maps.Map(document.getElementById('map'), mapOptions);
  
  setMarkers(map, markers);
}

function setMarkers(map, markers){
  for(let i = 0; i<markers.length; i++)
  {
    const currMarker = markers[i];
    const marker = new google.maps.Marker({
      position: {lat: currMarker[1] + Math.random()*0.02, lng: currMarker[2] + Math.random()*0.02},
      map,
      title: currMarker[0]
    });
  }
}