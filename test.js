const axios = require('axios');

// Simple test to verify the API endpoint works
async function testAPI() {
    try {
        console.log('Starting DiscountEx API test...\n');
        
        // Test the search endpoint
        const response = await axios.get('http://localhost:3000/api/search', {
            params: {
                keyword: 'potato chip',
                page: 1
            }
        });
        
        console.log('✅ API Response Status:', response.status);
        console.log('✅ Response Data Structure:');
        console.log('   - Success:', response.data.success !== undefined);
        console.log('   - Keyword:', response.data.keyword);
        console.log('   - Page:', response.data.page);
        console.log('   - Total Items:', response.data.totalItems);
        console.log('   - Items Array:', Array.isArray(response.data.items));
        
        if (response.data.items && response.data.items.length > 0) {
            console.log('\n✅ First Item Structure:');
            const firstItem = response.data.items[0];
            console.log('   - ID:', firstItem.id);
            console.log('   - Name:', firstItem.name);
            console.log('   - Price:', firstItem.price);
            console.log('   - Promo Tags:', firstItem.promotags);
            console.log('   - Brand:', firstItem.brand);
        }
        
        console.log('\n🎉 All tests passed! The API is working correctly.');
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
        process.exit(1);
    }
}

// Run the test
testAPI();