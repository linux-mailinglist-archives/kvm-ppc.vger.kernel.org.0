Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFBF3DDE19
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Aug 2021 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhHBQ4w (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 2 Aug 2021 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhHBQ4v (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 2 Aug 2021 12:56:51 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17354C06175F
        for <kvm-ppc@vger.kernel.org>; Mon,  2 Aug 2021 09:56:42 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id o32-20020a0c85a30000b0290328f91ede2bso13355859qva.1
        for <kvm-ppc@vger.kernel.org>; Mon, 02 Aug 2021 09:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qUyk13eLyEOR6oe2vEOVV1kByiwt+wSu/VyODCpu9Lg=;
        b=qTdlf41oYQ3fGX3v70dFvv9Cfb4TBTpqXUX1/LYjGGNmKYpSw5mF5vPd5q/l1IkftA
         Zo31WYzRjXjcnVmlNhriRcPKTtUNk43FRCR6rtsLEpPT0shk5nlRzIfKMLEFS5k7/UGF
         U6MK0M8ryORow6DQHeHKDu+tpGtAGOJOW0qbzebsm+9ArupTEMOF/SFSwFQtzbLiKaA3
         nWq85uJJAVPS5aX/RBuv2zo8gBqLcyTDHxFNMcchoblTErKDLsi2dFfUlPNjYkkRQjut
         hy1MNoFq4Y5Lg+vUzdA5Fiw2U5e2PCCI53Acd6e4NlojQbaLBL1RqUan7yiH7q6UeOiY
         9/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qUyk13eLyEOR6oe2vEOVV1kByiwt+wSu/VyODCpu9Lg=;
        b=Rgb+1+dQBjssixIi0qFwCOTC2VYPmTJKLrJo/RkXYw/Tpkqf3KzxVCVLPgwMUsL2WQ
         NeionAoebVpHrai4ZFpmQkdSSzgiW4LDv2KCt0WPiVUfjTWFGXu4WkPD7tVR0c4GqXrX
         50w4n1Uv1dw1jcBc8IQpRU+Md1y4dafgLnfL53vVy2yLvgFxr4mPt+h8uy00cy+psfYE
         v6w9wBnXsysmYvagrg/LlROw9X9P1XalRN45s9+mdgWav1Cbc3y4MPnaEWBt+63OOb1i
         ZE5PRkJJNx+5IoIE2qyLNhlW8om88+9RPmPzYdGL6FCHljvHwxL5wnbyNjtCrqZSS4Vi
         Opyg==
X-Gm-Message-State: AOAM530tHq1wkwkHe+nwt9V7RlaE6m7fARW+iTwjHdJu9pZZEJcNHfpK
        k3dqMCzxhYSSBASZcUriFO0UfC6qK0bHiFtrIg==
X-Google-Smtp-Source: ABdhPJzyn03FMrvI3DW2lujmYEnJN+51+he0wDLUXkIp4Sld9hR6wQIhMTytEAiSkkWBJFITdk7ZsaHzJTJ2VPs9sA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:2a3:: with SMTP id
 m3mr17080038qvv.55.1627923401274; Mon, 02 Aug 2021 09:56:41 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:31 +0000
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Message-Id: <20210802165633.1866976-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210802165633.1866976-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 3/5] KVM: selftests: Add checks for histogram stats
 bucket_size field
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The bucket_size field should be non-zero for linear histogram stats and
should be zero for other stats types.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 5906bbc08483..17f65d514915 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -109,6 +109,18 @@ static void stats_test(int stats_fd)
 		/* Check size field, which should not be zero */
 		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
 				pdesc->name);
+		/* Check bucket_size field */
+		switch (pdesc->flags & KVM_STATS_TYPE_MASK) {
+		case KVM_STATS_TYPE_LINEAR_HIST:
+			TEST_ASSERT(pdesc->bucket_size,
+			    "Bucket size of Linear Histogram stats (%s) is zero",
+			    pdesc->name);
+			break;
+		default:
+			TEST_ASSERT(!pdesc->bucket_size,
+			    "Bucket size of stats (%s) is not zero",
+			    pdesc->name);
+		}
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
 	/* Check overlap */
-- 
2.32.0.554.ge1b32706d8-goog

