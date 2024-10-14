const CONFIG = new Config({
  crypto: {
    coin: "ETH",
    currency: "USD",
    refreshIn: 10,
  },
  overrideStorage: true, // override localStorage with fixed userconfig values
  temperature: {
    location: "Paris, France",
    scale: "C",
  },
  clock: {
    format: "h:i p",
    iconColor: "#ff7b95",
  },
  search: {
    engines: {
      g: ["https://google.com/search?q=", "Google"],
      i: ["https://ixquick.com/do/search?q=", "Ixquick"],
      d: ["https://duckduckgo.com/html?q=", "DuckDuckGo"],
      y: ["https://youtube.com/results?search_query=", "Youtube"],
      w: ["https://en.wikipedia.org/w/index.php?search=", "Wikipedia"],
    },
  },
  keybindings: {
    //"t": 'todo-list',
    s: "search-bar",
    h: "tabs-list",
  },
  disabled: ["crypto-rate", "todo-list", "boards"],
  openLastVisitedTab: false,
  tabs: [
    {
      name: "main",
      background_url: "src/img/banners/bg-1.gif",
      categories: [
        {
          name: "mail",
          links: [
            {
              url: "https://mail.google.com/mail/u/0/#inbox",
              name: "gmail",
              icon: "brand-gmail",
            },
            {
              name: "outlook",
              url: "https://outlook.live.com/mail/0/",
              icon: "brand-windows",
            },
            {
              name: "yahoo",
              url: "https://mail.yahoo.com/d",
              icon: "brand-yahoo",
            },
            {
              name: "teams",
              url: "https://teams.microsoft.com/v2/?culture=en-us&country=us",
              icon: "brand-teams",
            },
          ],
        },
        {
          name: "google",
          links: [
            {
              name: "drive",
              url: "https://drive.google.com/drive/my-drive",
            },
            {
              name: "agenda",
              url: "https://calendar.google.com/calendar/u/0/r?pli=1w",
            },
            {
              name: "maps",
              url: "https://maps.google.com/",
            },
          ],
        },
        {
          name: "orga",
          links: [
            {
              name: "git",
              url: "https://github.com/",
            },
            {
              name: "trello",
              url: "https://trello.com/w/espacedetravail83756494",
            },
            {
              name: "todo",
              url: "https://todolistme.net/",
            },
            {
              name: "excalidraw",
              url: "https://excalidraw.com/",
            },
          ],
        },
      ],
    },
    {
      name: "tech",
      background_url: "src/img/banners/bg-2.gif",
      categories: [
        {
          name: "documentation",
          links: [
            {
              name: "epitech docs",
              url: "https://epitech-2022-technical-documentation.readthedocs.io/en/latest/",
            },
          ],
        },
        {
          name: "forums",
          links: [
            {
              name: "w3schools",
              url: "https://www.w3schools.com/",
            },
            {
              name: "stackoverflow",
              url: "https://text-compare.com/",
            },
            {
              name: "stackoverflow",
              url: "https://stackoverflow.com/",
            },
          ],
        },
        {
          name: "cheat-sheet",
          links: [
            {
              name: "nvim select",
              url: "https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt",
            },
            {
              name: "emacs keys",
              url: "https://www.gnu.org/software/emacs/refcards/pdf/refcard.pdf",
            },
            {
              name: "nvim",
              url: "https://neovim.io/doc/user/vimindex.html",
            },
            {
              name: "nerdfonts-icons",
              url: "https://www.nerdfonts.com/cheat-sheet",
            },
          ],
        },
      ],
    },
    {
      name: "utils",
      background_url: "src/img/banners/bg-3.gif",
      categories: [
        {
          name: "text-utils",
          links: [
            {
              name: "text compare",
              url: "https://text-compare.com/",
            },
            {
              name: "spelling checker",
              url: "https://www.scribens.fr/",
            },
            {
              name: "notepad",
              url: "https://notepad-online.com/fr/",
            },
          ],
        },
        {
          name: "epitech",
          links: [
            {
              name: "mouli",
              url: "https://my.epitech.eu/",
            },
            {
              name: "intra",
              url: "https://intra.epitech.eu/",
            },
            {
              name: "git - 2028",
              url: "https://github.com/EpitechPromo2028/",
            },
          ],
        },
      ],
    },
  ],
});
