Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F2A2A1C8
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfEXXuQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 May 2019 19:50:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36978 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfEXXuA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 May 2019 19:50:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id p15so4756186pll.4
        for <kvm-ppc@vger.kernel.org>; Fri, 24 May 2019 16:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T411oidtPZE/SyBXnA5xe/v4182CyfqCsIw7xcrtw7w=;
        b=h1Yfyhrm1FED0jxfY2I/NspMxRT5TIJwzEmWWjpN49QToxU9ZGZbpFbhec3ZLORRCd
         jpV/RHW2DQVuQ6REsHLluVgcp8J/8f7MfNBg8yuFJKeM4vTFRi3l37IN4VY1lkR3I9qd
         ZWKxvmGD+ntgFm02ZtggbTrE3nvbMGZd9Jwq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T411oidtPZE/SyBXnA5xe/v4182CyfqCsIw7xcrtw7w=;
        b=bUZwOJ6hZ7UUHpliEAMgF/cuRT+MIhfcflT2FLpJzNMVevUTvmKJZfUu82VYVNgZTg
         H2djWpQsUSVvhSgiVsLsCFSL8AePpiti8x+PgTxw83hp1agIUxhZGFwPGtHncpjoG9xa
         RB6zjDKgyd8kp1p4JnGHELwXhUxuujmk8atmUUzlOJ2okGfwvGoz4lIQxv8pMDOKN7Ld
         LGFbEpSyE2xn0EZbqtr6GBMIHOITPhrykjJnmTine4Cn0J1GwJpX6Hvcd2n/i+BAiS0p
         KXlFpCdQ6SvYVzErU9ja02SPJj/FNddEZF902AG9oJvNaTywgCXd4+J8tMBwAjSsOGpt
         G6uA==
X-Gm-Message-State: APjAAAU0gca9gqLi/LQ8UC+6jKVf0RckRLlDh11+Qg/UFKxoBy1zpuwe
        byOYYIhaswbYXZppSWsv6CngCg==
X-Google-Smtp-Source: APXvYqxwZl/5ewT5nmPHvDNF3PVcRdSTyjHQUf1i/UtDMZkPW0EhWp82Y0t5mSMFBjTrA/fFj21Rqg==
X-Received: by 2002:a17:902:4181:: with SMTP id f1mr87153377pld.22.1558741799771;
        Fri, 24 May 2019 16:49:59 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3297595pgb.39.2019.05.24.16.49.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 16:49:59 -0700 (PDT)
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
Subject: [PATCH RFC 3/5] hashtable: Use the regular hlist_for_each_entry_rcu API
Date:   Fri, 24 May 2019 19:49:31 -0400
Message-Id: <20190524234933.5133-4-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
In-Reply-To: <20190524234933.5133-1-joel@joelfernandes.org>
References: <20190524234933.5133-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

hlist_for_each_entry_rcu already does not do any tracing. This series
removes the notrace variant of it, so let us just use the regular API.

In a future patch, we can also remove the
hash_for_each_possible_rcu_notrace API that this patch touches.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/hashtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
index 417d2c4bc60d..47fa7b673c1b 100644
--- a/include/linux/hashtable.h
+++ b/include/linux/hashtable.h
@@ -189,7 +189,7 @@ static inline void hash_del_rcu(struct hlist_node *node)
  * not do any RCU debugging or tracing.
  */
 #define hash_for_each_possible_rcu_notrace(name, obj, member, key) \
-	hlist_for_each_entry_rcu_notrace(obj, \
+	hlist_for_each_entry_rcu(obj, \
 		&name[hash_min(key, HASH_BITS(name))], member)
 
 /**
-- 
2.22.0.rc1.257.g3120a18244-goog

