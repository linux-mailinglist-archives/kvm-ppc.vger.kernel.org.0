Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D4D11FD89
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 05:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLPETb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 23:19:31 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:34708 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfLPETa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 15 Dec 2019 23:19:30 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id E9312AE80564;
        Sun, 15 Dec 2019 23:18:18 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH kernel v2 0/4] Enable IOMMU support for pseries Secure VMs
Date:   Mon, 16 Dec 2019 15:19:20 +1100
Message-Id: <20191216041924.42318-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This enables IOMMU for SVM. Instead of sharing
a H_PUT_TCE_INDIRECT page, this uses H_PUT_TCE for mapping
and H_STUFF_TCE for clearing TCEs which should bring
acceptable performance at the boot time; otherwise things
work with the same speed anyway.

Please comment. Thanks.


This is based on sha1
37d4e84f765b Linus Torvalds Merge tag 'ceph-for-5.5-rc2' of git://github.com/ceph/ceph-client

Please comment. Thanks.



Alexey Kardashevskiy (3):
  powerpc/pseries: Allow not having
    ibm,hypertas-functions::hcall-multi-tce for DDW
  powerpc/pseries/iommu: Separate FW_FEATURE_MULTITCE to put/stuff
    features
  powerpc/pseries/svm: Allow IOMMU to work in SVM

Ram Pai (1):
  Revert "powerpc/pseries/iommu: Don't use dma_iommu_ops on secure
    guests"

 arch/powerpc/include/asm/firmware.h       |  6 ++-
 arch/powerpc/platforms/pseries/firmware.c | 10 +++-
 arch/powerpc/platforms/pseries/iommu.c    | 65 +++++++++++++----------
 3 files changed, 50 insertions(+), 31 deletions(-)

-- 
2.17.1

