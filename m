Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B03C93DE
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhGNWdh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Jul 2021 18:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbhGNWdh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 14 Jul 2021 18:33:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4A8C06175F
        for <kvm-ppc@vger.kernel.org>; Wed, 14 Jul 2021 15:30:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l16-20020a25cc100000b0290558245b7eabso4809668ybf.10
        for <kvm-ppc@vger.kernel.org>; Wed, 14 Jul 2021 15:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NLo2orw2GrujjOHbkY0DlGp9/FL5YLDeLP3ALI1aHhM=;
        b=G4hul3bnSLj9qvJAnOnLCK17khPm4foRgCTwXc4l4zgP2yieKnyScK2wI5PUMF8BUf
         Snj5M4N6oJjq9eyI8P9uKkPkxJme8112xSa899olrd4QJvobjBJafq4SaSvBM2RDogHq
         UfHY3z7ZaMgX/v3Pj0LyiRD1snrf53wFsnQDJUFc3KgWeJgKptjQz+U03NtkpBKr3++C
         M+UL3cUjkPqz+GRugB9zn67UJ9rqprl+atvKWF+00wbAxNvoF8UzEwbkG1M4scrD4KFZ
         hi6Sz4U7qmUvCWLh0c/SONN25bNkbYLC3tX3zjhXi7VMM7tyeUpi6Z/mtuAL77EKdGfi
         mxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NLo2orw2GrujjOHbkY0DlGp9/FL5YLDeLP3ALI1aHhM=;
        b=sM/v4htykRmyr/ICwlbS1DdLKEK771OJ2UWMmQqon5Tn2kH5qNB/2CoNiP0GrmraL9
         EI/vYkBz9RPQgaFq1KDbgd0cK2T9sjWH06m1mACkvCt04xrWr61TdSfnq1G8VQI7w+c3
         ZJyIWRpYnmZJa38BjLodRC3s4K8F91y2mb86neaodoqh1YCM47THcwwGqdkmzFlkPF7f
         PDJX17X49S7YPi1eaHqnWSiAcF12LJFosrXMfauOWvOpmHU3ffgbaWItdGV7+x5Yl3LC
         0Qw78vuj5zi29dEXgbd32S3bWt9RRMNbzzr29lznTyX2LkQFsMDtHw+94DWr1jQ7q/uQ
         bWTQ==
X-Gm-Message-State: AOAM5325DE0butvxl48heET0SFs2LAtRC059g+5PZLfNrS14EybuQd2J
        rLNpVgzJnHFPLda5jIZgMPPx9/+BuEmRCwJ3XA==
X-Google-Smtp-Source: ABdhPJwRpOHjHJzu/zQxNv/BIxT6+OmPYhVERu/lrtpL/BGir7IgLCbLCtnY47LxeFknQwTnK7DC7FRXYtPykbGkxA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:d912:: with SMTP id
 q18mr323595ybg.294.1626301843001; Wed, 14 Jul 2021 15:30:43 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:31 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 4/6] KVM: selftests: Add checks for histogram stats
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
2.32.0.402.g57bb445576-goog

