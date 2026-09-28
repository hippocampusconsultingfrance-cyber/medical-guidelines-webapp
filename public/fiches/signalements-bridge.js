/*
 * Pont entre le bouton « Signaler une erreur » des fiches et la base du site.
 *
 * La page des fiches (index.html, générée dans le dépôt rfe-sfar-website) a
 * été conçue pour l'aperçu claude.ai, où elle stocke les signalements via
 * window.claude.use('db'). Hors de claude.ai, cette fonction n'existe pas et
 * les signalements étaient perdus. Ce fichier fournit la même interface,
 * adossée à /api/signalements (table error_reports dans Supabase).
 *
 * Il est inséré dans index.html par scripts/prepare-fiches.mjs à chaque build.
 */
(function () {
  if (window.claude && window.claude.use) return;

  var cache = { isAdmin: false, reports: [] };
  var listeners = { reports: [], decisions: [] };

  function snapshot(docs) {
    return {
      docs: docs.map(function (d) {
        return { id: d.id, data: function () { return d; } };
      }),
    };
  }

  function notify() {
    listeners.reports.forEach(function (l) {
      l.next(snapshot(cache.reports));
    });
    listeners.decisions.forEach(function (l) {
      l.next(snapshot([]));
    });
  }

  function request(method, url, body) {
    return fetch(url, {
      method: method,
      credentials: "same-origin",
      headers: body ? { "Content-Type": "application/json" } : undefined,
      body: body ? JSON.stringify(body) : undefined,
    }).then(function (res) {
      var type = res.headers.get("content-type") || "";
      if (!res.ok || type.indexOf("application/json") === -1) {
        throw new Error("Erreur " + res.status);
      }
      return res.json();
    });
  }

  var loaded = null;
  function refresh() {
    loaded = request("GET", "/api/signalements").then(function (data) {
      cache.isAdmin = data.isAdmin === true;
      cache.reports = data.reports || [];
      notify();
      return cache;
    });
    return loaded;
  }

  function subscribe(name, next, error) {
    var l = { next: next, error: error || function () {} };
    listeners[name].push(l);
    (loaded || refresh()).then(
      function () {
        next(snapshot(name === "reports" ? cache.reports : []));
      },
      function (err) {
        l.error(err);
      },
    );
    return function () {
      listeners[name] = listeners[name].filter(function (x) {
        return x !== l;
      });
    };
  }

  function collection(name) {
    var query = {
      orderBy: function () { return query; },
      limit: function () { return query; },
      onSnapshot: function (next, error) {
        return subscribe(name, next, error);
      },
      add: function (report) {
        if (name !== "reports") return Promise.reject(new Error("Non pris en charge"));
        return request("POST", "/api/signalements", {
          doc: report.doc,
          docTitle: report.docTitle,
          section: report.section,
          description: report.description,
        }).then(function (created) {
          refresh();
          return { id: created.id };
        });
      },
      doc: function (id) {
        return {
          set: function (value) {
            if (name !== "decisions") return Promise.reject(new Error("Non pris en charge"));
            return request("PATCH", "/api/signalements/" + encodeURIComponent(id), {
              status: value && value.status,
            }).then(function () {
              refresh();
            });
          },
        };
      },
    };
    return query;
  }

  var db = {
    collection: collection,
    doc: function (path) {
      return {
        // La page teste les droits administrateur en tentant d'écrire
        // « admin_check/self » : on répond selon le rôle enregistré en base.
        set: function () {
          if (path !== "admin_check/self") return Promise.reject(new Error("Non pris en charge"));
          return (loaded || refresh()).then(function () {
            if (!cache.isAdmin) throw new Error("Accès réservé");
          });
        },
      };
    },
  };

  window.claude = {
    use: function (name) {
      return Promise.resolve(name === "db" ? db : null);
    },
  };
})();
