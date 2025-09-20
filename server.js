const express = require('express');
const axios = require('axios');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Route to serve the main HTML page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// API route to scrape Wellcome data
app.get('/api/search', async (req, res) => {
    try {
        const { keyword = 'potato chip', page = 1 } = req.query;
        
        // Make request to Wellcome API
        const response = await axios.get('https://www.wellcome.com.hk/api/item/wareSearch', {
            params: {
                keyword: keyword,
                page: page
            },
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Accept': 'application/json, text/plain, */*',
                'Accept-Language': 'en-US,en;q=0.9',
                'Referer': 'https://www.wellcome.com.hk/',
            }
        });

        // Extract and format the data
        const data = response.data;
        
        // Parse the response to extract items with basic info
        let items = [];
        if (data && data.data && data.data.items) {
            items = data.data.items.map(item => ({
                id: item.id,
                name: item.name || item.displayName || 'No name available',
                price: item.price || item.currentPrice || 'Price not available',
                originalPrice: item.originalPrice || item.listPrice,
                promotags: item.promotags || item.promoTags || [],
                imageUrl: item.imageUrl || item.image,
                brand: item.brand,
                description: item.description
            }));
        }
        
        res.json({
            success: true,
            keyword: keyword,
            page: page,
            totalItems: items.length,
            items: items
        });
        
    } catch (error) {
        console.error('Error scraping Wellcome API:', error.message);
        
        // Return mock data for demonstration if API is not accessible
        const mockItems = [
            {
                id: 'mock1',
                name: 'Lay\'s Potato Chips Original',
                price: 'HK$12.90',
                originalPrice: 'HK$15.90',
                promotags: ['20% OFF', 'SPECIAL OFFER'],
                imageUrl: '',
                brand: 'Lay\'s',
                description: 'Classic original flavor potato chips'
            },
            {
                id: 'mock2', 
                name: 'Pringles Sour Cream & Onion',
                price: 'HK$18.50',
                originalPrice: 'HK$22.90',
                promotags: ['BUY 2 GET 1 FREE'],
                imageUrl: '',
                brand: 'Pringles',
                description: 'Delicious sour cream and onion flavored chips'
            },
            {
                id: 'mock3',
                name: 'Calbee Potato Chips Seaweed',
                price: 'HK$8.90',
                originalPrice: null,
                promotags: ['NEW ARRIVAL'],
                imageUrl: '',
                brand: 'Calbee',
                description: 'Japanese style seaweed flavored potato chips'
            }
        ];
        
        res.json({
            success: false,
            error: 'Unable to access Wellcome API, showing mock data',
            keyword: req.query.keyword || 'potato chip',
            page: req.query.page || 1,
            totalItems: mockItems.length,
            items: mockItems
        });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});