


##################Welcome to my Master's Thesis project############# (esto en el infex.md)



theme: jekyll-theme-minimal
title: "Spadefoot Toads RNAseq Analysis"
description: "Exploring Developmental Plasticity in Spadefoot Toads through Transcriptomics"

# Customize your site
show_downloads: true
google_analytics: [Your Google Analytics tracking ID]

# Include custom CSS or HTML in header or footer
header:
  overlay_color: "#60a917"  # An earthy green tone, reflecting biology
  overlay_image: /assets/bg-header.jpg  # A background image related to your thesis

# Navigation Bar
navbar_links:
  - title: "Home"
    url: "/"
  - title: "Workflow"
    url: "/workflow"
  - title: "Results"
    url: "/results"
  - title: "About"
    url: "/about"

# Footer settings
footer:
  links:
    - title: "GitHub Repository"
      url: [Your GitHub Repository URL]
    - title: "Contact"
      url: "mailto:[Your Email]"



Updated index.md:
markdown
Copy code
---
layout: default
title: Home
nav_order: 1
description: "Welcome to my Master's Thesis Project on Spadefoot Toads RNAseq Analysis"
permalink: /
---

# Exploring Developmental Plasticity in Spadefoot Toads
## A Journey Through RNAseq Analysis

![Cover Image](/assets/cover.jpg)  <!-- A relevant cover image -->

Welcome to my Master's Thesis project page! Here, I document my journey in exploring the developmental plasticity of Spadefoot Toads using RNA sequencing (RNAseq). This project aims to uncover the genetic underpinnings of how these fascinating creatures adapt and evolve.

### The RNAseq Workflow
Our journey through RNAseq analysis encompasses several crucial steps, each detailed with images and insights:

1. **RNA Extraction**
   ![RNA Extraction](/assets/rna-extraction.jpg)  
   [More about RNA Extraction](/workflow#rna-extraction)

2. **RNA Quality Control**
   ![RNA Quality Control](/assets/rna-quality-control.jpg)  
   [More about RNA Quality Control](/workflow#rna-quality-control)

3. **Library Preparation**
   ![Library Preparation](/assets/library-preparation.jpg)  
   [More about Library Preparation](/workflow#library-preparation)

4. **Sequencing**
   ![Sequencing](/assets/sequencing.jpg)  
   [More about Sequencing](/workflow#sequencing)

5. **Sequence Quality Control**
   ![Sequence Quality Control](/assets/sequence-quality-control.jpg)  
   [More about Sequence Quality Control](/workflow#sequence-quality-control)

6. **Alignment and Mapping**
   ![Alignment and Mapping](/assets/alignment-mapping.jpg)  
   [More about Alignment and Mapping](/workflow#alignment-mapping)

7. **Quantification of Gene Expression**
   ![Gene Expression Quantification](/assets/gene-expression-quantification.jpg)  
   [More about Gene Expression Quantification](/workflow#gene-expression-quantification)

8. **Differential Expression Analysis**
   ![Differential Expression Analysis](/assets/differential-expression-analysis.jpg)  
   [More about Differential Expression Analysis](/workflow#differential-expression-analysis)

9. **Functional Enrichment Analysis**
   ![Functional Enrichment Analysis](/assets/functional-enrichment-analysis.jpg)  
   [More about Functional Enrichment Analysis](/workflow#functional-enrichment-analysis)

### Results
Our findings reveal intriguing aspects of developmental plasticity in Spadefoot Toads. [Discover our results](/results).

### About This Project
Learn more about the motivation, background, and methodology of this research in the [About section](/about).

### Stay Connected
Follow the journey and join the discussion on [GitHub](Your GitHub Repository URL).
Notes:
Images: Remember to replace the placeholders with actual images relevant to each step in your RNAseq workflow. These images should be informative and enhance the understanding of each step.

Links: Adjust the links to point to the correct sections or pages on your GitHub repository that provide more detailed explanations or results for each step.



## hot to use the following things 

/ (root)
|-- index.html
|-- css/
|   |-- style.css
|-- js/
|   |-- script.js
|-- assets/
    |-- images/
        |-- your-image.jpg




Clickable Graphics with HTML and JavaScript:
Clickable graphics can trigger actions, such as opening a modal, redirecting to another page, or displaying additional information.

Example: Clickable Image Redirecting to Another Page

<a href="/workflow#rna-extraction">
  <img src="/assets/rna-extraction.jpg" alt="RNA Extraction" style="cursor: pointer;">
</a>
This HTML snippet makes an image clickable, redirecting the user to a specific section of your page when clicked.


Custom JavaScript: If you're adding custom JavaScript, place your scripts in a .js file within your repository and link to it within your HTML files.
Testing: Always test your interactive elements thoroughly to ensure they work as expected across different browsers and devices.
Performance: Keep an eye on the performance impact of your interactive features, especially if you're loading external libraries.


Hover Effects with CSS:
Hover effects can be applied to images, buttons, or links, changing their appearance when the mouse pointer is over them. This is purely done with CSS.

Example: Changing Image Opacity on Hover
html
Copy code
<style>
.hover-effect {
  transition: opacity 0.5s ease;
  opacity: 1;
}

.hover-effect:hover {
  opacity: 0.6;
}
</style>

<img src="/assets/my-image.jpg" class="hover-effect" alt="Descriptive Text">
This CSS snippet makes an image slightly transparent when hovered over, with a smooth transition effect.


Your index.html (or any other HTML file) will contain the structure of your page, including references to your CSS for styles and JavaScript files for functionality.

html
Copy code
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<img src="assets/images/your-image.jpg" alt="Descriptive Text" class="hover-effect" id="clickableImage">

<script src="js/script.js"></script>
</body>
</html>
Step 3: Add CSS for Hover Effects
In your css/style.css file, add CSS rules for your hover effects. This example changes the opacity of images when hovered over.

css
Copy code
.hover-effect {
    transition: opacity 0.5s ease;
    opacity: 1;
}

.hover-effect:hover {
    opacity: 0.75;
}
Step 4: Add JavaScript for Clickable Graphics
In your js/script.js file, add JavaScript to handle the click event on your graphic. This example shows an alert when the image is clicked, but you could modify it to perform other actions, like opening a modal or redirecting to another page.

javascript
Copy code
document.getElementById('clickableImage').addEventListener('click', function() {
    alert('You clicked the image!');
});
Step 5: Link Everything in Your HTML
Make sure your HTML file correctly references the CSS and JavaScript files, as shown in Step 2. Your HTML file should link to the style.css file within the <head> section and to the script.js file right before the closing </body> tag to ensure the page styles and functionality load correctly.

Step 6: Test Your Page
After you've set up your files and coded your hover and click effects, test your page. You can do this locally on your computer, or if you're using GitHub Pages, you can push your changes to your GitHub repository and visit your GitHub Pages URL to see your work in action.