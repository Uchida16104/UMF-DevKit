int numParticles = 120;
float[] px, py, vx, vy, hue;
int bgColor;

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100, 100);
  bgColor = 0;

  px = new float[numParticles];
  py = new float[numParticles];
  vx = new float[numParticles];
  vy = new float[numParticles];
  hue = new float[numParticles];

  for (int i = 0; i < numParticles; i++) {
    px[i] = random(width);
    py[i] = random(height);
    vx[i] = random(-1.5, 1.5);
    vy[i] = random(-1.5, 1.5);
    hue[i] = random(360);
  }
}

void draw() {
  fill(bgColor, 0, 10, 18);
  noStroke();
  rect(0, 0, width, height);

  for (int i = 0; i < numParticles; i++) {
    px[i] += vx[i];
    py[i] += vy[i];

    if (px[i] < 0 || px[i] > width)  vx[i] *= -1;
    if (py[i] < 0 || py[i] > height) vy[i] *= -1;

    hue[i] = (hue[i] + 0.4) % 360;

    for (int j = i + 1; j < numParticles; j++) {
      float d = dist(px[i], py[i], px[j], py[j]);
      if (d < 100) {
        float alpha = map(d, 0, 100, 80, 0);
        stroke(hue[i], 80, 90, alpha);
        line(px[i], py[i], px[j], py[j]);
      }
    }

    noStroke();
    fill(hue[i], 90, 100, 90);
    ellipse(px[i], py[i], 5, 5);
  }

  fill(0, 0, 100, 80);
  noStroke();
  textSize(14);
  text("UMF-DevKit — Processing (Java) Particle Network", 20, 30);
  text("Particles: " + numParticles + "  |  FPS: " + nf(frameRate, 0, 1), 20, 52);
}

void mousePressed() {
  for (int i = 0; i < 10; i++) {
    int idx = (int) random(numParticles);
    px[idx] = mouseX + random(-20, 20);
    py[idx] = mouseY + random(-20, 20);
    vx[idx] = random(-2, 2);
    vy[idx] = random(-2, 2);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    for (int i = 0; i < numParticles; i++) {
      px[i] = random(width);
      py[i] = random(height);
      vx[i] = random(-1.5, 1.5);
      vy[i] = random(-1.5, 1.5);
    }
  }
}
