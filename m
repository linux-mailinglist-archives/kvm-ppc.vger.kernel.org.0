Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D8E282796
	for <lists+kvm-ppc@lfdr.de>; Sun,  4 Oct 2020 02:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgJDAXk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 3 Oct 2020 20:23:40 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:49296 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgJDAXj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 3 Oct 2020 20:23:39 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2020 20:23:39 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id ACF1918000890
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Oct 2020 00:18:18 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 821CB837F24A;
        Sun,  4 Oct 2020 00:18:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3872:4250:4321:5007:6261:6742:10004:10848:11026:11473:11658:11914:12043:12297:12555:12895:13069:13311:13357:13894:14096:14181:14384:14394:14721:21080:21627:30054:30089,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: chalk68_201509d271b1
X-Filterd-Recvd-Size: 2027
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sun,  4 Oct 2020 00:18:15 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Davidlohr Bueso <dave@stgolabs.net>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: PPC: Book3S HV: Make struct kernel_param_ops definition const
Date:   Sat,  3 Oct 2020 17:18:06 -0700
Message-Id: <d130e88dd4c82a12d979da747cc0365c72c3ba15.1601770305.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1601770305.git.joe@perches.com>
References: <cover.1601770305.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This should be const, so make it so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4ba06a2a306c..2b215852cdc9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -111,7 +111,7 @@ module_param(one_vm_per_core, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a core (requires indep_threads_mode=N)");
 
 #ifdef CONFIG_KVM_XICS
-static struct kernel_param_ops module_param_ops = {
+static const struct kernel_param_ops module_param_ops = {
 	.set = param_set_int,
 	.get = param_get_int,
 };
-- 
2.26.0

