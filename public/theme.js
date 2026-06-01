/*
 * theme.js — TEACHING POINT
 * This file reads the ACTIVE_THEME variable that is injected
 * by the CI/CD pipeline at build time (via sed/envsubst).
 *
 * To change the festival theme, just update the GitHub secret
 * ACTIVE_THEME = "diwali" | "christmas" | "holi" | "default"
 * Push to main → pipeline deploys → site updates. Zero manual work.
 */

const ACTIVE_THEME = "{{ACTIVE_THEME}}";   /* replaced by pipeline */

const themes = {
  default: {
    banner: null,
    headline: "Order food &amp; groceries online",
    sub: "Hot food delivered in 30 minutes. Fresh groceries at your doorstep.",
    offers: [
      { icon: "🎉", text: "50% off on first order" },
      { icon: "⚡", text: "Free delivery above ₹299" },
      { icon: "🍔", text: "Burgers from ₹99" },
      { icon: "🛒", text: "Groceries in 10 mins" }
    ]
  },

  diwali: {
    banner: "✨ Happy Diwali! Flat 60% off on all orders today — Use code DIWALI60 ✨",
    headline: "Celebrate Diwali with <br>delicious food!",
    sub: "Festival specials delivered to your doorstep. Light up your celebration with great food!",
    sparkles: true,
    offers: [
      { icon: "🪔", text: "Diwali Special — 60% OFF" },
      { icon: "🎆", text: "Free sweets above ₹499" },
      { icon: "✨", text: "Festival combos from ₹199" },
      { icon: "🎁", text: "Gift a meal to someone" }
    ]
  },

  christmas: {
    banner: "🎄 Merry Christmas! Free delivery on all orders today — No code needed 🎁",
    headline: "Spread Christmas joy <br>with great food!",
    sub: "Santa's bringing the best food to your door. Free delivery on us today!",
    offers: [
      { icon: "🎄", text: "Christmas Special — Free delivery" },
      { icon: "🎅", text: "Santa's combo meals from ₹299" },
      { icon: "⛄", text: "Winter warmers — Soups & more" },
      { icon: "🎁", text: "Gift vouchers available" }
    ]
  },

  holi: {
    banner: "🌈 Happy Holi! Colourful discounts — Up to 40% off on festive platters 🌈",
    headline: "Play Holi, eat well,<br>celebrate life!",
    sub: "Holi special thalis and drinks delivered in 30 minutes. Let the colours fly!",
    offers: [
      { icon: "🌈", text: "Holi platters — 40% off" },
      { icon: "🍹", text: "Thandai & drinks from ₹49" },
      { icon: "🎨", text: "Festival combos — feeds 4" },
      { icon: "🪅", text: "Free dessert above ₹399" }
    ]
  },

  valentine: {
    banner: "💝 Happy Valentine's Day! Free dessert on every order today — Code: LOVE25 💝",
    headline: "Share love with<br>delicious food!",
    sub: "Surprise your special someone with their favourite meal delivered in 30 minutes.",
    hearts: true,
    offers: [
      { icon: "💝", text: "Valentine special — Free dessert" },
      { icon: "🍫", text: "Couple combos from ₹399" },
      { icon: "🌹", text: "Chocolate platters from ₹199" },
      { icon: "💌", text: "Send a meal as a gift" }
    ]
  },

  independence: {
    banner: "🇮🇳 Happy Independence Day! Free delivery on all orders — Jai Hind! 🇮🇳",
    headline: "Celebrate freedom with<br>great Indian food!",
    sub: "Desi flavours delivered to your doorstep. Free delivery on us today — Jai Hind!",
    flags: true,
    offers: [
      { icon: "🇮🇳", text: "Independence Day — Free delivery" },
      { icon: "🍛", text: "Desi thalis from ₹149" },
      { icon: "🎆", text: "Tricolour combos — 47% off" },
      { icon: "🥘", text: "Regional specials today only" }
    ]
  }
};

(function applyTheme() {
  const key = (ACTIVE_THEME && themes[ACTIVE_THEME]) ? ACTIVE_THEME : "default";
  const t = themes[key];

  /* Apply data-theme attribute for CSS variables */
  if (key !== "default") document.documentElement.setAttribute("data-theme", key);

  /* Banner */
  const banner = document.getElementById("festival-banner");
  if (t.banner && banner) {
    banner.textContent = t.banner;
    banner.classList.remove("hidden");
  }

  /* Headline & sub */
  const h1 = document.getElementById("hero-headline");
  const sub = document.getElementById("hero-sub");
  if (h1) h1.innerHTML = t.headline;
  if (sub) sub.textContent = t.sub;

  /* Offer pills */
  t.offers.forEach((o, i) => {
    const pill = document.getElementById("offer-pill-" + (i + 1));
    if (pill) {
      pill.querySelector(".offer-icon").textContent = o.icon;
      pill.querySelector("span:last-child").textContent = o.text;
    }
  });

  /* Diwali sparkles */
  if (t.sparkles) {
    const sparkleEmojis = ["✨", "🪔", "🎆", "⭐", "💫"];
    setInterval(() => {
      const s = document.createElement("div");
      s.className = "sparkle";
      s.textContent = sparkleEmojis[Math.floor(Math.random() * sparkleEmojis.length)];
      s.style.left = Math.random() * 100 + "vw";
      s.style.animationDuration = (2 + Math.random() * 3) + "s";
      s.style.fontSize = (14 + Math.random() * 16) + "px";
      document.body.appendChild(s);
      setTimeout(() => s.remove(), 5000);
    }, 600);
  }

  /* Valentine hearts */
  if (t.hearts) {
    const heartEmojis = ["💝", "💖", "💗", "💓", "❤️", "💕", "🌹"];
    setInterval(() => {
      const h = document.createElement("div");
      h.className = "heart-float";
      h.textContent = heartEmojis[Math.floor(Math.random() * heartEmojis.length)];
      h.style.left = Math.random() * 100 + "vw";
      h.style.animationDuration = (3 + Math.random() * 3) + "s";
      h.style.fontSize = (14 + Math.random() * 18) + "px";
      h.style.animationDelay = (Math.random() * 2) + "s";
      document.body.appendChild(h);
      setTimeout(() => h.remove(), 6000);
    }, 700);
  }

  /* Independence Day flag particles */
  if (t.flags) {
    const colors = ["#FF6700", "#FFFFFF", "#138808", "#000080"];
    setInterval(() => {
      const f = document.createElement("div");
      f.className = "flag-particle";
      f.style.left = Math.random() * 100 + "vw";
      f.style.background = colors[Math.floor(Math.random() * colors.length)];
      f.style.animationDuration = (3 + Math.random() * 3) + "s";
      f.style.animationDelay = (Math.random() * 2) + "s";
      document.body.appendChild(f);
      setTimeout(() => f.remove(), 6000);
    }, 400);
  }

  console.log("[Swiggy Clone] Theme applied:", key);
})();
