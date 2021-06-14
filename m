Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E363A5BB5
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Jun 2021 04:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhFNC5R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 13 Jun 2021 22:57:17 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:50710 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhFNC5R (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 13 Jun 2021 22:57:17 -0400
Received: by mail-pl1-f201.google.com with SMTP id j11-20020a170902758bb02900ec9757f3dbso4024088pll.17
        for <kvm-ppc@vger.kernel.org>; Sun, 13 Jun 2021 19:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G0BvcWLb4IeXiMagmDzrz7Uqmh6mNFjQeYSUfBYTeS0=;
        b=J5d2R6fWgIT7owLOkJV6VeWqsPNmA3XhITMy2ACzrDEZhT0Hlwu1Mv1CGvxmT9xZEJ
         zOh45iAE5qCbYIz/1wXZBdrottBUD7tpMTeePsXb7v9pq1MVKNz/w44zNDX5DV7GJSNw
         tUg2JDh1hnHw8Fct0UeMIcmZl+UUTt3HJqYS4yXoEOYYItYDzo+7W04DATqfZNjGj0EE
         FJ4jtuO3fwrMXv+WswutYrXdpiDAx3BQTTnr1PTdXUUB8IPOb33aV1KfvgYWQbQSHSW+
         jN4K6ERakZJxjI6TqbwlCEllee61z7OrSO6pbKuyV3wieGgx7IAhVQP6z/uCtPoNXmQE
         gfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G0BvcWLb4IeXiMagmDzrz7Uqmh6mNFjQeYSUfBYTeS0=;
        b=m83uUl0hr76Qyvd0n3SkkPDSi7bbXJrI++Wk7QwHU5tWFpY6z66D0IQ43lF/S5yOLw
         s008UyC3Q2WGastyzTL6hLExb+xpp+4W4cP0U3IAfjHNFgGqGQ3X2oC6Bxeg3lXRyzkb
         szZYpJi3SSyk8P6fR2URFAnf3iHR09QhAB57lIjXL9gopYvTIbzl39CMlneZ2I7vq2xQ
         09srVjN29gs43luBXSQYY8ZsocE691s3sOox5YLJXo0ixIYPzdc4u/6O/bwk4FUgt+5S
         gEG/lpaRkwE1GSG/mZIOpm5YdLq6XSLamaCh5MWFt7kU4R9oPuA+6zoqztsxJJiGQAFx
         PWVw==
X-Gm-Message-State: AOAM533GnJnxBD+/uAsD2hbvYp05XjVaSEHITMz7KhaTrPRVkgR5igyd
        i2rveeD8pVRvwxL83/z02BW8r65R6GINlNlWlA==
X-Google-Smtp-Source: ABdhPJycgiFSbxMZLS8Bil1CYzhmeCE7vWg07Yh1drE2XVuoYrfaHxoRxI6LH8bCvEcGVqokSkYhAgwO3CRfAtV4/A==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:ed4d:: with SMTP id
 m13mr15005137pgk.433.1623639242315; Sun, 13 Jun 2021 19:54:02 -0700 (PDT)
Date:   Mon, 14 Jun 2021 02:53:51 +0000
In-Reply-To: <20210614025351.365284-1-jingzhangos@google.com>
Message-Id: <20210614025351.365284-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 4/4] KVM: selftests: Update binary stats test for stats mode
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Update binary stats selftest to support sanity test for stats
read/write mode and offset.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index d85859a6815a..2a34b5e822e8 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -77,6 +77,8 @@ static void stats_test(int stats_fd)
 				<= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
 		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
 				<= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
+		TEST_ASSERT((pdesc->flags & KVM_STATS_MODE_MASK)
+				<= KVM_STATS_MODE_MAX, "Unknown KVM stats mode");
 		/* Check exponent for stats unit
 		 * Exponent for counter should be greater than or equal to 0
 		 * Exponent for unit bytes should be greater than or equal to 0
@@ -106,11 +108,18 @@ static void stats_test(int stats_fd)
 	}
 	/* Check overlap */
 	TEST_ASSERT(header->data_offset >= header->desc_offset
-			|| header->data_offset + size_data <= header->desc_offset,
-			"Data block is overlapped with Descriptor block");
+		|| header->data_offset + size_data <= header->desc_offset,
+		"Data block is overlapped with Descriptor block");
 	/* Check validity of all stats data size */
 	TEST_ASSERT(size_data >= header->count * sizeof(stats_data->value[0]),
 			"Data size is not correct");
+	/* Check stats offset */
+	for (i = 0; i < header->count; ++i) {
+		pdesc = (void *)stats_desc + i * size_desc;
+		TEST_ASSERT(pdesc->offset < size_data,
+			"Invalid offset (%u) for stats: %s",
+			pdesc->offset, pdesc->name);
+	}
 
 	/* Allocate memory for stats data */
 	stats_data = malloc(size_data);
-- 
2.32.0.272.g935e593368-goog

