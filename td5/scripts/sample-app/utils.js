// utils.js
function formatName(raw) {
  if (!raw) return null;
  const name = String(raw).trim();
  if (name.length === 0) return null;
  return name;
}

module.exports = { formatName };
