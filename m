Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A643111E003
	for <lists+kvm-ppc@lfdr.de>; Fri, 13 Dec 2019 09:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbfLMI4L (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 13 Dec 2019 03:56:11 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:60176 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfLMI4L (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 13 Dec 2019 03:56:11 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 77389AE8001D;
        Fri, 13 Dec 2019 03:44:37 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH kernel 0/3] Enable IOMMU support for pseries Secure VMs
Date:   Fri, 13 Dec 2019 19:45:34 +1100
Message-Id: <20191213084537.27306-1-aik@ozlabs.ru>
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



Alexey Kardashevskiy (2):
  powerpc/pseries: Allow not having
    ibm,hypertas-functions::hcall-multi-tce for DDW
  powerpc/pseries/iommu: Do not use H_PUT_TCE_INDIRECT in secure VM

Ram Pai (1):
  powerpc/pseries/iommu: Use dma_iommu_ops for Secure VM.

 arch/powerpc/platforms/pseries/iommu.c | 59 +++++++++++++++-----------
 1 file changed, 34 insertions(+), 25 deletions(-)

-- 
2.17.1

