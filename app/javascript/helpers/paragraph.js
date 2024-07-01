export function truncateByWords(text, wordLimit) {
  const words = text.split(' ');

  if (words.length <= wordLimit) {
    return text;
  }

  return words.slice(0, wordLimit).join(' ') + '...';
}