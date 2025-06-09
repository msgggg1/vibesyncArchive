document.addEventListener('DOMContentLoaded', () => {
  const mode = document.querySelector('#mode');
  const back_btn = document.querySelector('.back_icon');
  if (back_btn != null) {
    back_btn.addEventListener('click', () => {
      window.history.back();
    })
  }

  const sidebar = document.getElementById('sidebar');
  if (sidebar != null) {
    const btn = document.getElementById('toggle-btn');
    sidebar.classList.add('collapsed');
    btn.textContent = '✖';

    function checkWidth() {
      if (window.innerWidth <= 1000) {
        btn.style.display = 'block';
        btn.style.position = 'fixed';
        // collapsed 상태이면 content margin 0
        if (sidebar.classList.contains('collapsed')) {
          btn.textContent = '☰';
        }
      } else {
        btn.style.display = 'none';
        sidebar.classList.remove('collapsed');
        btn.textContent = '✖';
      }
    }

    btn.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed');
      // toggle에 따라 content margin 동기화
      const content = document.getElementById('content');
      if (sidebar.classList.contains('collapsed')) {
        btn.textContent = '☰';
      } else {
        btn.textContent = '✖';
      }
    });

    window.addEventListener('resize', checkWidth);
    checkWidth();
  }

  if (mode.value === 'main') {
    console.log(mode.value);
    const swiper1 = new Swiper('#swiper1', {
      loop: true,
      slidesPerView: 'auto',
      centeredSlides: true,
      spaceBetween: 0,
      autoplay: true,
      navigation: {
        nextEl: '#next',
        prevEl: '#prev',
      }
    });
  
    const swiper2 = new Swiper('#swiper2', {
      loop: false,
      navigation: {
        nextEl: '#next2',
        prevEl: '#prev2',
      },
      breakpoints: {
        0: {
          slidesPerView: 1,
          spaceBetween: 10,
          centeredSlides: true
        },
        600: {
          slidesPerView: 3,
          spaceBetween: 10,
          centeredSlides: false
        }
      },
      on: {
        init: function () {
          updateNavButtons(this);
        },
        slideChange: function () {
          updateNavButtons(this);
        },
      },
    });
  
    function updateNavButtons(swiper) {
      const prevBtn = document.querySelector('#prev2');
      const nextBtn = document.querySelector('#next2');
      if (swiper.activeIndex === 0) {
        prevBtn.classList.add('swiper-button-disabled');
      } else {
        prevBtn.classList.remove('swiper-button-disabled');
      }
      if (swiper.activeIndex >= swiper.slides.length - swiper.params.slidesPerView) {
        nextBtn.classList.add('swiper-button-disabled');
      } else {
        nextBtn.classList.remove('swiper-button-disabled');
      }
    }
    
    function initRotatingHighlight(containerId, interval = 2800) {
            console.log(`Initializing rotating highlight for ${containerId}`);
            const container = document.getElementById(containerId);
            if (!container) {
                console.warn(`Container with ID ${containerId} not found.`);
                return;
            }
            const items = container.querySelectorAll('.list-entry');
            if (items.length === 0) {
                return;
            }

            let currentIndex = Math.floor(Math.random() * items.length);

            function resetItems() {
                items.forEach(item => {
                    item.classList.remove('active-highlight');
                });
            }

            function highlightItem(index) {
                if (items[index]) {
                    items[index].classList.add('active-highlight');
                }
            }

            resetItems();
            highlightItem(currentIndex);
            console.log(`Initial highlight for ${containerId}: item index ${currentIndex}`);

            setInterval(() => {
                resetItems();
                currentIndex = (currentIndex + 1) % items.length;
                highlightItem(currentIndex);
            }, interval);
        }
    
        initRotatingHighlight('recent_posts_container', 2800);
        initRotatingHighlight('popular_posts_container', 2800);
        initRotatingHighlight('popular_users_container', 2800);
        
  } else if (mode.value === 'workspace') {
    console.log(mode.value);
    const plusbtn = document.querySelector('#content_plus');
    const contentsGrid = document.querySelector('#contents_grid');
    const maxItems = 8; // 최대 아이템 개수

    plusbtn.addEventListener('click', function() {
      const contentsItems = contentsGrid.querySelectorAll('.contents_item');

      if (contentsItems.length < maxItems) {
        const newItem = document.createElement('div');
        newItem.classList.add('contents_item');
        contentsGrid.insertBefore(newItem, plusbtn);

        if (contentsGrid.querySelectorAll('.contents_item').length === maxItems) {
          plusbtn.style.display = 'none';
        }

        console.log(contentsGrid.innerHTML);
      }
    });

    // 페이지 로드시 아이템 개수 확인 및 plusbtn 초기 상태 설정
    function checkItemCount() {
      const initialItems = contentsGrid.querySelectorAll('.contents_item');
      if (initialItems.length >= maxItems) {
        plusbtn.style.display = 'none';
      } else {
        plusbtn.style.display = 'block';
      }
    }
    checkItemCount();
  } /*else if (mode.value === 'board') {
    loadFullBoardData(10);
    function loadFullBoardData(maxPage) {
      const posts = [];
      for (let i = 1; i <= 150; i++) {
        posts.push({ id: i, title: "Dummy Title" + i });
      }
      
      const postsPerPage = maxPage;
      let currentPage = 1;
      const totalPages = Math.ceil(posts.length / postsPerPage);
      const fullListEl = document.getElementById('full-list');
      const paginationEl = document.getElementById('pagination');
      
      function renderPage(page) {
        currentPage = page;
        fullListEl.innerHTML = '';
        const start = (page - 1) * postsPerPage;
        const end = start + postsPerPage;
        const pagePosts = posts.slice(start, end);
        
        pagePosts.forEach(post => {
          const postDiv = document.createElement('div');
          postDiv.className = 'full-post';
          postDiv.setAttribute('data-post-id', post.id);
          postDiv.innerHTML = `<div class="post-index">${post.id}</div><div class="post-title">${post.title}</div>`;
          fullListEl.appendChild(postDiv);
        });
        renderPagination();
      }
      
      function renderPagination() {
        paginationEl.innerHTML = '';
      
        // "<<" First-page button
        const firstBtn = document.createElement('button');
        firstBtn.classList.add('subfont');
        firstBtn.textContent = '<<';
        // hide on first page
        firstBtn.style.display = currentPage === 1 ? 'none' : '';
        firstBtn.addEventListener('click', () => renderPage(1));
        paginationEl.appendChild(firstBtn);
      
        // Prev button
        const prevBtn = document.createElement('button');
        prevBtn.classList.add('subfont');
        prevBtn.textContent = 'prev';
        prevBtn.disabled = currentPage === 1;
        prevBtn.style.display = currentPage === 1 ? 'none' : '';
        prevBtn.addEventListener('click', () => {
          if (currentPage > 1) renderPage(currentPage - 1);
        });
        paginationEl.appendChild(prevBtn);
      
        // Page-number buttons (window of 5)
        const pageGroupSize = 5;
        const groupStart = Math.floor((currentPage - 1) / pageGroupSize) * pageGroupSize + 1;
        const groupEnd = Math.min(groupStart + pageGroupSize - 1, totalPages);
        for (let i = groupStart; i <= groupEnd; i++) {
          const pageBtn = document.createElement('button');
          pageBtn.textContent = i;
          if (i === currentPage) {
            pageBtn.disabled = true;
            pageBtn.style.fontWeight = 'bold';
            pageBtn.style.fontSize = '18px';
          }
          pageBtn.addEventListener('click', () => renderPage(i));
          paginationEl.appendChild(pageBtn);
        }
      
        // Next button
        const nextBtn = document.createElement('button');
        nextBtn.classList.add('subfont');
        nextBtn.textContent = 'next';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.style.display = currentPage === totalPages ? 'none' : '';
        nextBtn.addEventListener('click', () => {
          if (currentPage < totalPages) renderPage(currentPage + 1);
        });
        paginationEl.appendChild(nextBtn);
      
        // ">>" Last-page button
        const lastBtn = document.createElement('button');
        lastBtn.classList.add('subfont');
        lastBtn.textContent = '>>';
        // hide on last page
        lastBtn.style.display = currentPage === totalPages ? 'none' : '';
        lastBtn.addEventListener('click', () => renderPage(totalPages));
        paginationEl.appendChild(lastBtn);
      }
      
      renderPage(1);
    }
  }*/ else if (mode.value === 'user') {
    setOffsetHeight();
    function setOffsetHeight() {
      console.log('user resize')
      const con_list = document.querySelectorAll('.con_item');
      con_list.forEach((item) => {
        const currentWidth = item.offsetWidth;
        const changeHeight = (currentWidth * 5) / 4;
        item.style.height = `${changeHeight}px`;
      })
    }

    window.addEventListener('resize', setOffsetHeight);

  } else if (mode.value === 'login') {
    const login = document.querySelector('#login')
    const singup = document.querySelector('#signUp')
    const changeSingup = document.querySelector('#changeSingup')
    const changeLogin = document.querySelector('#changeLogin')

    changeSingup.addEventListener('click', () => {
      console.log('gosignup')
      login.style.display = "none";
      singup.style.display = "flex";
    })

    changeLogin.addEventListener('click', () => {
      console.log('gologin')
      login.style.display = "flex";
      singup.style.display = "none";
    })
  }
  
});
