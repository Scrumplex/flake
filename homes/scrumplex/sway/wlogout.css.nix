''
  window {
    font-family: "Fira Code";
    font-size: 10pt;
    color: #cdd6f4;  /* text */
  }

  button {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    border: none;
    background-color: #1e1e2e;
  }

  button:hover {
    background-color: #313244;  /* surface0 */
  }

  button:focus {
    background-color: #89b4fa;  /* blue */
    color: #1e1e2e;  /* base */
  }

  button:active {
    background-color: #cdd6f4;  /* text */
    color: #1e1e2e;  /* base */
  }

  #lock {
    background-image: image(url("${./lock.png}"));
  }

  #exit {
    background-image: image(url("${./exit-to-app.png}"));
  }

  #suspend {
    background-image: image(url("${./power-sleep.png}"));
  }

  #hibernate {
    background-image: image(url("${./power-cycle.png}"));
  }

  #shutdown {
    background-image: image(url("${./power.png}"));
  }

  #reboot {
    background-image: image(url("${./restart.png}"));
  }
''
