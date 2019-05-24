Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3602B2A1C6
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 01:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfEXXuO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 May 2019 19:50:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46433 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfEXXuF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 May 2019 19:50:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so1340939pfm.13
        for <kvm-ppc@vger.kernel.org>; Fri, 24 May 2019 16:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4IUQP+uKyCN66rRAguQBd+uSI/nPEDtpoZNPuNABz7k=;
        b=ExaDqp0kDit6EEuSOcT+FAdLJsr3wasxUTshDnisEPTxiqbsM/iwHBlK5jmEac4uTx
         1WrmYkFMfBW8Hthn8w/kr+CT1si+DUZOuwzHNsk8UBPZv3PhzihaZaVz4saSEqQb9A8/
         P62/INsuK+8WFv0NR63C1VMqjfsXLMIYivmZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IUQP+uKyCN66rRAguQBd+uSI/nPEDtpoZNPuNABz7k=;
        b=mQhXBGLipBdPxmmleAwtfOXw+CmJNEtsdyaBPy3Ey2+uk5mkAccprX0zeZbG332Q7C
         IPnEy90bq7Il7ZzuCUg6dkUhCW/pm9p1uGQG+KcTZ6Aq7S48R23NFETLLNKVjWQffmwG
         Fl5wq90CPxJ3+1uGN+utIatNmiRb+AcXnp+ZpxGqMRZk29lE+5FHhlmkN7VodrKCyo2g
         Ayp4zC2gbrfExmO+2LRwF03G/uZTEtFDLfuLioNayDrdw64yA022vtfosrDWgnl+ay5k
         z6UVNvI9odhOUMfAVgpxGdbfujsVJBN5BnAouXI4vrW4ELnG+GceIPg8HaalO1iBVp2n
         siDQ==
X-Gm-Message-State: APjAAAXeRLkDiAoCYXiJXZHkcnnBXpu6bdGEPnGxr1aeCf/W6LaZWRvW
        givokyrXraXJDls62Fanx9sD+w==
X-Google-Smtp-Source: APXvYqxNGBpXom3Ado94lkiXFHwXNMChLcccb7ZkYxRn6dsfk/n65WIEwwfbkGKCqFKqFYilSX8ODw==
X-Received: by 2002:a17:90a:372a:: with SMTP id u39mr12987526pjb.19.1558741804955;
        Fri, 24 May 2019 16:50:04 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3297595pgb.39.2019.05.24.16.50.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 16:50:04 -0700 (PDT)
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
Subject: [PATCH RFC 5/5] rcu: Remove rcu_dereference_raw_notrace since no users
Date:   Fri, 24 May 2019 19:49:33 -0400
Message-Id: <20190524234933.5133-6-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
In-Reply-To: <20190524234933.5133-1-joel@joelfernandes.org>
References: <20190524234933.5133-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The series removes all users of the API and with this patch, the API
itself. Also fix documentation.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 Documentation/RCU/Design/Requirements/Requirements.html | 6 +++---
 include/linux/rcupdate.h                                | 9 ---------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/Documentation/RCU/Design/Requirements/Requirements.html b/Documentation/RCU/Design/Requirements/Requirements.html
index 5a9238a2883c..9727278893e6 100644
--- a/Documentation/RCU/Design/Requirements/Requirements.html
+++ b/Documentation/RCU/Design/Requirements/Requirements.html
@@ -2512,9 +2512,9 @@ disabled across the entire RCU read-side critical section.
 <p>
 It is possible to use tracing on RCU code, but tracing itself
 uses RCU.
-For this reason, <tt>rcu_dereference_raw_notrace()</tt>
-is provided for use by tracing, which avoids the destructive
-recursion that could otherwise ensue.
+This is the other reason for using, <tt>rcu_dereference_raw()</tt>,
+for use by tracing, which avoids the destructive recursion that could
+otherwise ensue.
 This API is also used by virtualization in some architectures,
 where RCU readers execute in environments in which tracing
 cannot be used.
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 922bb6848813..f917a27fc115 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -472,15 +472,6 @@ static inline void rcu_preempt_sleep_check(void) { }
 	__rcu_dereference_check((p), (c) || rcu_read_lock_sched_held(), \
 				__rcu)
 
-/*
- * The tracing infrastructure traces RCU (we want that), but unfortunately
- * some of the RCU checks causes tracing to lock up the system.
- *
- * The no-tracing version of rcu_dereference_raw() must not call
- * rcu_read_lock_held().
- */
-#define rcu_dereference_raw_notrace(p) __rcu_dereference_check((p), 1, __rcu)
-
 /**
  * rcu_dereference_protected() - fetch RCU pointer when updates prevented
  * @p: The pointer to read, prior to dereferencing
-- 
2.22.0.rc1.257.g3120a18244-goog

