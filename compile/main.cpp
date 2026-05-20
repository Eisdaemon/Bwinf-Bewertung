#include <bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>

//#pragma GCC optimize("O3")
//#pragma GCC target("avx,avx2,fma")
//#pragma GCC optimization ("unroll-loops")
//#pragma GCC target("avx,avx2,sse,sse2,sse3,sse4,popcnt")

using namespace std;
using namespace __gnu_pbds;
#define int long long
#define float long double
#define elif else if
#define endl "\n"
#define mod 1000000007
#define pi acos(-1)
#define eps 0.000000001
#define inf 1000'000'000'000'000'000LL
#define FIXED(a) cout << fixed << setprecision(a)
#define all(x) x.begin(), x.end()
#define rall(x) x.rbegin(), x.rend()
#define time_init auto start = std::chrono::high_resolution_clock::now()
#define time_report                                       \
    auto end = std::chrono::high_resolution_clock::now(); \
    std::cout << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << " ms" << endl
#define debug(x) \
    { cerr << #x << " = " << x << endl; }
#define len(x) (int) x.size()
#define sqr(x) ((x) * (x))
#define cube(x) ((x) * (x) * (x))
#define bit(x, i) (((x) >> (i)) & 1)
#define set_bit(x, i) ((x) | (1LL << (i)))
#define clear_bit(x, i) ((x) & (~(1LL << (i))))
#define toggle_bit(x, i) ((x) ^ (1LL << (i)))
#define low_bit(x) ((x) & (-(x)))
#define count_bit(x) __builtin_popcountll(x)
#define srt(x) sort(all(x))
#define rsrt(x) sort(rall(x))
#define mp make_pair
#define maxel(x) (*max_element(all(x)))
#define minel(x) (*min_element(all(x)))
#define maxelpos(x) (max_element(all(x)) - x.begin())
#define minelpos(x) (min_element(all(x)) - x.begin())
#define sum(x) (accumulate(all(x), 0LL))
#define product(x) (accumulate(all(x), 1LL, multiplies<int>()))
#define gcd __gcd
#define lcm(a, b) ((a) / gcd(a, b) * (b))
#define rev(x) (reverse(all(x)))
#define shift_left(x, k) (rotate(x.begin(), x.begin() + k, x.end()))
#define shift_right(x, k) (rotate(x.rbegin(), x.rbegin() + k, x.rend()))
#define is_sorted(x) (is_sorted_until(all(x)) == x.end())
#define is_even(x) (((x) &1) == 0)
#define is_odd(x) (((x) &1) == 1)
#define pow2(x) (1LL << (x))
#define rep(i, n) for(int i = 0; i < (n); i++)

struct custom_hash {
    static uint64_t splitmix64(uint64_t x) {
        // http://xorshift.di.unimi.it/splitmix64.c
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }

    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM = chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};

template<typename T>
using min_heap = priority_queue<T, vector<T>, greater<T>>;
template<typename T>
using max_heap = priority_queue<T, vector<T>, less<T>>;
template<typename T>
using ordered_set = tree<T, null_type, less<T>, rb_tree_tag, tree_order_statistics_node_update>;
template<typename T>
using ordered_multiset = tree<T, null_type, less_equal<T>, rb_tree_tag, tree_order_statistics_node_update>;
template<typename T>
using matrix = vector<vector<T>>;
template<typename T>
using graph = vector<vector<T>>;
using hashmap = gp_hash_table<int, int, custom_hash>;

template<typename T>
vector<T> vect(int n, T val) {
    return vector<T>(n, val);
}

template<typename T>
vector<vector<T>> vect(int n, int m, T val) {
    return vector<vector<T>>(n, vector<T>(m, val));
}

template<typename T>
vector<vector<vector<T>>> vect(int n, int m, int k, T val) {
    return vector<vector<vector<T>>>(n, vector<vector<T>>(m, vector<T>(k, val)));
}

template<typename T>
vector<vector<vector<vector<T>>>> vect(int n, int m, int k, int l, T val) {
    return vector<vector<vector<vector<T>>>>(n, vector<vector<vector<T>>>(m, vector<vector<T>>(k, vector<T>(l, val))));
}

template<typename T>
matrix<T> new_matrix(int n, int m, T val) {
    return matrix<T>(n, vector<T>(m, val));
}

template<typename T>
graph<T> new_graph(int n) {
    return graph<T>(n);
}

template<class T, class S>
inline bool chmax(T &a, const S &b) {
    return (a < b ? a = b, 1 : 0);
}

template<class T, class S>
inline bool chmin(T &a, const S &b) {
    return (a > b ? a = b, 1 : 0);
}

using i8 = int8_t;
using i16 = int16_t;
using i32 = int32_t;
using i64 = int64_t;
using i128 = __int128_t;
using u8 = uint8_t;
using u16 = uint16_t;
using u32 = uint32_t;
using u64 = uint64_t;
using u128 = __uint128_t;

template<typename T>
using vec = vector<T>;

using pII = pair<int, int>;
template<typename T>
using enumerated = pair<T, int>;

template<typename T>
istream &operator>>(istream &is, vec<T> &v) {
    for (int &x: v) is >> x;
    return is;
}

template<typename T>
ostream &operator<<(ostream &os, const vec<T> &v) {
    for (int i = 0; i < len(v); i++) {
        if (i) os << " ";
        os << v[i];
    }
    return os;
}


namespace ST {

    template<typename T, typename P>
    struct SegmentTree {
    private:
        function<T(const T &, const T &)> comb;
        function<void(T &, const P, int, int)> apply_push;
        function<void(P &, const P &)> merge_push;
        function<pair<P, P>(const P &, int l, int r, int pos)> split_push;
        size_t n;
        vec<T> tree;
        vec<optional<P>> pushes;

        void push(int v, int tl, int tr) {
            if (!pushes[v].has_value())
                return;
            if (tl != tr) {
                int tm = (tl + tr) / 2;
                auto [l, r] = split_push(pushes[v].value(), tl, tr, tm);
                apply_push(tree[2 * v], l, tl, tm);
                apply_push(tree[2 * v + 1], r, tm + 1, tr);
                if (pushes[2 * v].has_value())
                    merge_push(pushes[2 * v].value(), l);
                else
                    pushes[2 * v] = l;
                if (pushes[2 * v + 1].has_value())
                    merge_push(pushes[2 * v + 1].value(), r);
                else
                    pushes[2 * v + 1] = r;
            }

            pushes[v] = nullopt;
        }

        void build(int v, int tl, int tr, const vec<T> &a) {
            if (tl == tr) {
                tree[v] = a[tl];
                return;
            }
            int tm = (tl + tr) / 2;
            build(2 * v, tl, tm, a);
            build(2 * v + 1, tm + 1, tr, a);
            tree[v] = comb(tree[2 * v], tree[2 * v + 1]);
        }

        T get(int v, int tl, int tr, int l, int r) {
            if (l > r)
                return T();
            if (l == tl && r == tr)
                return tree[v];
            push(v, tl, tr);
            int tm = (tl + tr) / 2;
            if (r <= tm)
                return get(2 * v, tl, tm, l, r);
            if (l > tm)
                return get(2 * v + 1, tm + 1, tr, l, r);

            return comb(get(2 * v, tl, tm, l, tm), get(2 * v + 1, tm + 1, tr, tm + 1, r));
        }

        void update(int v, int tl, int tr, int l, int r, const P &val) {
            if (l > r)
                return;
            if (l == tl && r == tr) {
                apply_push(tree[v], val, l, r);
                if (pushes[v].has_value())
                    merge_push(pushes[v].value(), val);
                else
                    pushes[v] = val;
                return;
            }
            push(v, tl, tr);
            int tm = (tl + tr) / 2;
            if (r <= tm)
                update(2 * v, tl, tm, l, r, val);
            elif (l > tm)update(2 * v + 1, tm + 1, tr, l, r, val);
            else {
                auto [lval, rval] = split_push(val, l, r, tm);
                update(2 * v, tl, tm, l, tm, lval);
                update(2 * v + 1, tm + 1, tr, tm + 1, r, rval);
            }
            tree[v] = comb(tree[2 * v], tree[2 * v + 1]);
        }

        int most_left(int v, int tl, int tr, int l, int r, const function<bool(T)> &check) {
            push(v, tl, tr);
            if (tl == l and tr == r and !check(tree[v]))
                return -1;
            if (tl == tr)
                return tl;
            int tm = (tl + tr) / 2;
            if (r <= tm)
                return most_left(2 * v, tl, tm, l, r, check);
            if (l > tm)
                return most_left(2 * v + 1, tm + 1, tr, l, r, check);
            int res = most_left(2 * v, tl, tm, l, tm, check);
            if (res == -1)
                return most_left(2 * v + 1, tm + 1, tr, tm + 1, r, check);
            return res;
        }

        int most_right(int v, int tl, int tr, int l, int r, const function<bool(T)> &check) {
            push(v, tl, tr);
            if (tl == l and tr == r and !check(tree[v]))
                return n;
            if (tl == tr)
                return tl;
            int tm = (tl + tr) / 2;
            if (r <= tm)
                return most_right(2 * v, tl, tm, l, r, check);
            if (l > tm)
                return most_right(2 * v + 1, tm + 1, tr, l, r, check);
            int res = most_right(2 * v + 1, tm + 1, tr, tm + 1, r, check);
            if (res == n)
                return most_right(2 * v, tl, tm, l, tm, check);
            return res;
        }

    public:

        SegmentTree(
                const function<T(const T &, const T &)> &comb,
                const function<void(T &, const P, int, int)> &apply_push,
                const function<void(P &, const P &)> &merge_push,
                const function<pair<P, P>(const P &, int l, int r, int pos)> &split_push) :
                comb(comb), apply_push(apply_push), merge_push(merge_push), split_push(split_push) {

        }

        int most_left(int l, int r, const function<bool(T)> &check) {
            return most_left(1, 0, n - 1, l, r, check);
        }

        int most_right(int l, int r, const function<bool(T)> &check) {
            return most_right(1, 0, n - 1, l, r, check);
        }

        T get(int l, int r) {
            return get(1, 0, n - 1, l, r);
        }

        T operator[](int i) {
            return get(i, i);
        }

        T operator()(int l, int r) {
            return get(l, r);
        }

        void update(int l, int r, const P &val) {
            update(1, 0, n - 1, l, r, val);
        }

        void update(int l, const P &val) {
            update(1, 0, n - 1, l, l, val);
        }

        void init(int _n, const vec<T> &a) {
            this->n = _n;
            tree.clear();
            pushes.clear();
            tree.resize(4 * n);
            pushes.resize(4 * n);
            build(1, 0, n - 1, a);
        }

        void init(const vec<T> &a) {
            init(len(a), a);
        }

        void init(int _n, const T &val) {
            init(_n, vect<T>(_n, val));
        }

        void reset() {
            fill(all(tree), T());
            fill(all(pushes), nullopt);
        }

    };


    namespace Generators {
        template<typename T>
        SegmentTree<T, T> set_max() {
            return SegmentTree<T, T>([](const T &a, const T &b) { return max(a, b); },                     // comb
                                     [](T &a, const T &b, int l, int r) { a = b; },                        // apply_push
                                     [](T &a, const T &b) { a = b; },                                      // merge_push
                                     [](const T &p, int tl, int tr, int pos) { return mp(p, p); });        // split_push
        }

        template<typename T>
        SegmentTree<T, T> set_min() {
            return SegmentTree<T, T>([](const T &a, const T &b) { return min(a, b); },                     // comb
                                     [](T &a, const T &b, int l, int r) { a = b; },                        // apply_push
                                     [](T &a, const T &b) { a = b; },                                      // merge_push
                                     [](const T &p, int tl, int tr, int pos) { return mp(p, p); });        // split_push
        }

        template<typename T>
        SegmentTree<T, T> set_sum() {
            return SegmentTree<T, T>([](const T &a, const T &b) { return a + b; },                         // comb
                                     [](T &a, const T &b, int l, int r) {                                  // apply_push
                                         a = b * (r - l + 1);
                                     },
                                     [](T &a, const T &b) { a = b; },                                      // merge_push
                                     [](const T &p, int tl, int tr, int pos) { return mp(p, p); });        // split_push
        }

        template<typename T>
        SegmentTree<T, T> add_max() {
            return SegmentTree<T, T>([](const T &a, const T &b) { return max(a, b); },                     // comb
                                     [](T &a, const T &b, int l, int r) {                                  // apply_push
                                         a += b;
                                     },
                                     [](T &a, const T &b) { a += b; },                                     // merge_push
                                     [](const T &p, int tl, int tr, int pos) { return mp(p, p); });        // split_push
        }

        template<typename T>
        SegmentTree<T, T> add_min() {
            return SegmentTree<T, T>([](const T &a, const T &b) { return min(a, b); },                     // comb
                                     [](T &a, const T &b, int l, int r) {                                  // apply_push
                                         a += b;
                                     },
                                     [](T &a, const T &b) { a += b; },                                     // merge_push
                                     [](const T &p, int tl, int tr, int pos) { return mp(p, p); });        // split_push
        }

        template<typename T>
        SegmentTree<T, T> add_sum() {
            return SegmentTree<T, T>([](const T &a, const T &b) { return a + b; },                         // comb
                                     [](T &a, const T &b, int l, int r) {                                  // apply_push
                                         a += b * (r - l + 1);
                                     },
                                     [](T &a, const T &b) { a += b; },                                     // merge_push
                                     [](const T &p, int tl, int tr, int pos) { return mp(p, p); });        // split_push
        }
    }
//
//    using Push = int;
//    using Vertex = int;
//    auto split_push = [](const Push &p, int tl, int tr, int pos) {
//        return mp(p, p);
//    };
//
//    auto merge_push = [](Push &p, const Push &q) {
//        p = q;
//    };
//
//    auto apply_push = [](Vertex &x, const Push &p, int l, int r) {
//        x = p;
//    };
//    auto comb = [](const Vertex &x, const Vertex &y) {
//        return max(x, y);
//    };
//
//    SegmentTree<Vertex, Push> stree(comb, apply_push, merge_push, split_push);

}

#ifdef LOCAL
mt19937 randEngine(0);
#else
mt19937 randEngine(chrono::steady_clock::now().time_since_epoch().count());
#endif

int randInt(int l, int r) {
    return uniform_int_distribution<int>(l, r)(randEngine);
}

float randFloat(float l, float r) {
    return uniform_real_distribution<float>(l, r)(randEngine);
}

signed main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    int C = 1e6;
    cin >> C;
    auto stree = ST::Generators::set_max<int>();
    stree.init(C, 0);
    int q = 1e6;
    cin >> q;
    int ans = 0;
    while (q--) {
        int t;
        cin >> t;
        if (t == 1) {
            int l, r, x;
            cin >> l >> r >> x;
            l--;
            r--;
            stree.update(l, r, x);
        } else {
            int l, r;
            cin >> l >> r;
            l--;
            r--;
            ans += stree.get(l, r);
        }
    }
    cout << ans << endl;
}