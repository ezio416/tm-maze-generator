// c 2024-06-26
// m 2024-06-27

vec4 RandomColor(float alpha = 1.0f) {
    return vec4(Math::Rand(0.0f, 1.0f), Math::Rand(0.0f, 1.0f), Math::Rand(0.0f, 1.0f), alpha);
}

int Round(float f) {
    return int(Math::Round(f));
}
