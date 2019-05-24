Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7072A1BE
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 01:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfEXXuD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 May 2019 19:50:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39352 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfEXXuD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 May 2019 19:50:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id z26so6195060pfg.6
        for <kvm-ppc@vger.kernel.org>; Fri, 24 May 2019 16:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eaayBc92IMmJypjY+VABsd2ojMmm1ZzkUdujrOQbc5g=;
        b=bKtwgdrkqRsODjat6ojYHyBKdVvveA/eZWmIfkN9EasXwK9Os8rI42a213oMZywyrJ
         uQqACXEmiJkk4pse9iu30fuVl4njrGuVeGY+qNGodI9qLCrR7wmHRld8PBOzHPJpRXLn
         hVJS0T152ByGYPSSVahtJqoeq8R8jylKj9qpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eaayBc92IMmJypjY+VABsd2ojMmm1ZzkUdujrOQbc5g=;
        b=sKoMOvvcHJOQzO6apol8zbedRiBZuhdgn4nm81FqRreb9Vi1xuG1dVLje+K1iJAbuu
         SM2yCkhI6X1HaJkJQtpz2ad6jA3Ah9DmYEohombpvKqO4A/uOlxizyvOwJGNqf3+iouv
         DzVM4tycoAdGZ0x7hY3z4XkmYMt1khVtITaoDOVoPoASjzYFMms8EJIcTcs3sxv6q4h9
         MvHVziOWWEsjvK7wCrABJhJe6auTLZmWhbnILYpi2JvipzVAhy5+zvanB/wVS8stBeMf
         O0TqobKscbppb8RLrI067iKwUoEW1Kd0NQi0AtdIB60b2r2OvfLarMqg3QWH83Kh5HKQ
         MwnQ==
X-Gm-Message-State: APjAAAXWFu/3G6RBD11kvb8mmWvZ184hdy6HqQKr0mtFmlY7F7Po/DpB
        MhG5H5qw1J4ZjP8ByI5lFgvJFA==
X-Google-Smtp-Source: APXvYqxnwdALM9KRFwXLedWKJxMEgotFtqy5TZBUssjnizX6ClUg18TxOqEWpFQcyOGvp5/8X0oLPg==
X-Received: by 2002:a17:90a:b296:: with SMTP id c22mr13322972pjr.28.1558741802356;
        Fri, 24 May 2019 16:50:02 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3297595pgb.39.2019.05.24.16.49.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 16:50:01 -0700 (PDT)
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
Subject: [PATCH RFC 4/5] rculist: Remove hlist_for_each_entry_rcu_notrace since no users
Date:   Fri, 24 May 2019 19:49:32 -0400
Message-Id: <20190524234933.5133-5-joel@joelfernandes.org>
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
itself.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 .clang-format           |  1 -
 include/linux/rculist.h | 20 --------------------
 2 files changed, 21 deletions(-)

diff --git a/.clang-format b/.clang-format
index 2ffd69afc1a8..aa935923f5cb 100644
--- a/.clang-format
+++ b/.clang-format
@@ -287,7 +287,6 @@ ForEachMacros:
   - 'hlist_for_each_entry_from_rcu'
   - 'hlist_for_each_entry_rcu'
   - 'hlist_for_each_entry_rcu_bh'
-  - 'hlist_for_each_entry_rcu_notrace'
   - 'hlist_for_each_entry_safe'
   - '__hlist_for_each_rcu'
   - 'hlist_for_each_safe'
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e91ec9ddcd30..0d3d77cf4f07 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -628,26 +628,6 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
 		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
 			&(pos)->member)), typeof(*(pos)), member))
 
-/**
- * hlist_for_each_entry_rcu_notrace - iterate over rcu list of given type (for tracing)
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as hlist_add_head_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- *
- * This is the same as hlist_for_each_entry_rcu() except that it does
- * not do any RCU debugging or tracing.
- */
-#define hlist_for_each_entry_rcu_notrace(pos, head, member)			\
-	for (pos = hlist_entry_safe (rcu_dereference_raw_notrace(hlist_first_rcu(head)),\
-			typeof(*(pos)), member);			\
-		pos;							\
-		pos = hlist_entry_safe(rcu_dereference_raw_notrace(hlist_next_rcu(\
-			&(pos)->member)), typeof(*(pos)), member))
-
 /**
  * hlist_for_each_entry_rcu_bh - iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
-- 
2.22.0.rc1.257.g3120a18244-goog

