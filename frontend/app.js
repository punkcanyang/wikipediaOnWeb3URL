document.addEventListener('DOMContentLoaded', () => {
    fetch('api-result-DEMO.json')
        .then(response => response.json())
        .then(data => {
            const content = data.query.pages["243421"].revisions[0].slots.main["*"];
            const htmlContent = convertWikiTextToHTML(content);
            document.getElementById('content').innerHTML = htmlContent;
        })
        .catch(error => console.error('Error loading JSON:', error));
});

function convertWikiTextToHTML(wikiText) {
    // Here you would use a library to convert WikiText to HTML
    // For example, using Showdown for Markdown:
    // const converter = new showdown.Converter();
    // return converter.makeHtml(wikiText);

    // A simplified example of manual conversion (replace with library usage)
    let html = wikiText
        .replace(/'''(.+?)'''/g, '<strong>$1</strong>') // bold
        .replace(/''(.+?)''/g, '<em>$1</em>'); // italic
    return html;
}
