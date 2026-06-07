<!-- Blog Preview Section -->
<section class="bg-deep-black border-top border-white-5" style="padding: 7rem 0;">
    <div class="container py-5">
        <div class="row mb-5 align-items-end">
            <div class="col-md-8 mx-auto text-center mb-4">
                <h5 class="text-primary small fw-bold mb-3 text-uppercase tracking-widest">Ideas que anticipan el futuro
                    de los datos</h5>
                <h2 class="display-5 text-white mb-3">Insights & <span class="text-gradient">Tech Blog</span></h2>
                <p class="text-white-50 mx-auto mb-4" style="max-width: 500px;">Compartimos análisis, tendencias y
                    resúmenes de arquitecturas aplicables a la realidad de tu empresa.</p>
                <div class="d-flex flex-wrap justify-content-center gap-2">
                    <button
                        class="btn btn-sm rounded-pill px-4 py-2 uppercase fw-bold tracking-widest filter-btn active"
                        onclick="filterBlog('all')">Todos</button>
                    <?php foreach ($blogCategories as $bCat): ?>
                        <button class="btn btn-sm rounded-pill px-4 py-2 uppercase fw-bold tracking-widest filter-btn"
                            onclick="filterBlog('<?php echo $bCat['slug']; ?>')">
                            <?php echo $bCat['name']; ?>
                        </button>
                    <?php endforeach; ?>
                </div>
            </div>
        </div>

        <div class="row g-4" id="blog-grid">
            <?php foreach ($latestPosts as $post): ?>
                <div class="col-md-4 blog-item" data-category="<?php echo $post['slug']; ?>">
                    <div class="card h-100 border-white-10 bg-midnight overflow-hidden hover-lift transition-all">
                        <img src="<?php echo $post['featured_image']; ?>" class="card-img-top"
                            alt="<?php echo $post['title']; ?>" style="height: 200px; object-fit: cover;">
                        <div class="card-body p-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <span class="badge rounded-pill x-small"
                                    style="background-color: <?php echo $post['category_color']; ?>;"><?php echo $post['category_name']; ?></span>
                                <span
                                    class="text-white-50 x-small"><?php echo date('M d, Y', strtotime($post['published_at'])); ?></span>
                            </div>
                            <h5 class="text-white fw-bold h6 mb-3"><?php echo $post['title']; ?></h5>
                            <p class="text-white-50 x-small mb-4 line-clamp-2"><?php echo $post['excerpt']; ?></p>
                            <a href="<?php echo url('blog/post/' . $post['slug']); ?>"
                                class="text-primary text-decoration-none small fw-bold d-flex align-items-center gap-2">
                                Leer Más <span class="material-symbols-outlined fs-6">east</span>
                            </a>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <div class="text-center mt-5">
            <a href="<?php echo url('blog'); ?>"
                class="btn btn-primary px-4 py-3 shadow-gold fw-bold uppercase tracking-widest">Seguir leyendo</a>
        </div>
    </div>
</section>
