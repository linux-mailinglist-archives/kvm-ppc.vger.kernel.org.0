Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C338E2A1C3
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 01:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfEXXt4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 May 2019 19:49:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38665 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfEXXtz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 May 2019 19:49:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id b76so6191965pfb.5
        for <kvm-ppc@vger.kernel.org>; Fri, 24 May 2019 16:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWprfXxnZYwrSMlSa8B0jYY+Kk48KO4t7l+blfnMKTI=;
        b=FtBgIcfyzP/9kJsM+zqDbKcy6VZwEKAANCQ1/eZQrD6rviA4awDDcac9F6JHAeC8Ww
         /QISOXT5+haCwcCXiDtBTzmrbvUPQt/eQFfssAfxoublccYDf4cZJhSHGojIabZd0IPc
         VxKmmE96CtJBAuxlrRyraOLObouJSFe2WI5dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWprfXxnZYwrSMlSa8B0jYY+Kk48KO4t7l+blfnMKTI=;
        b=lhG6GDgC8e1YXl4mE/8kLTcPrfudyYhDmYZjIJpMTIQuKffNpTKXGT5hs2+KG1zUS8
         tkqHxTqY7VYxbKjVwIOx472KQ8a5gkyJ0uRA9LbN+erljpbbCh1OF/gTujoBFskIeunB
         WuDuMT+vUL7XIkL6sUIZE8u5nlkYU3jMGZ5eplWKJsWk+XL3OOYEPRHZxPRSIG6RxVUE
         iUeCFS1MY7JgyrSMcmnKuA4/cl9PJ5rJ+Hjqfr6ozeVcEj5DW7DPZW/MX6VDnYIwDkg5
         cwGgHqkmYf7evNMeHsBE3pivCby2IoZ0Mtos/WnlNtrk67RN6k27wHcVRrnaQQamWOJT
         ARzw==
X-Gm-Message-State: APjAAAXJD9fgINfNlDlVZeDODAlj1XvHcvjd7LKY1TXsXfJx1/9e1yVz
        RU70Qm7EA7Km6omwb9VTfIL/cg==
X-Google-Smtp-Source: APXvYqz7Pfyyr4nOlV734fVH1bvjX4jHzTMPj1aZT0g/Pt0V2GglxzMFOH0INg1fPuB6UlDmRBFhmw==
X-Received: by 2002:a63:495e:: with SMTP id y30mr65431636pgk.185.1558741794604;
        Fri, 24 May 2019 16:49:54 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3297595pgb.39.2019.05.24.16.49.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 16:49:53 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RFC 1/5] powerpc: Use regular rcu_dereference_raw API
Date:   Fri, 24 May 2019 19:49:29 -0400
Message-Id: <20190524234933.5133-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
In-Reply-To: <20190524234933.5133-1-joel@joelfernandes.org>
References: <20190524234933.5133-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

rcu_dereference_raw already does not do any tracing. There is no need to
use the _notrace variant of it and this series removes that API, so let us
use the regular variant here.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 21b1ed5df888..c15c9bbf0206 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -546,7 +546,7 @@ static inline void note_hpte_modification(struct kvm *kvm,
  */
 static inline struct kvm_memslots *kvm_memslots_raw(struct kvm *kvm)
 {
-	return rcu_dereference_raw_notrace(kvm->memslots[0]);
+	return rcu_dereference_raw(kvm->memslots[0]);
 }
 
 extern void kvmppc_mmu_debugfs_init(struct kvm *kvm);
-- 
2.22.0.rc1.257.g3120a18244-goog

