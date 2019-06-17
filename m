Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89083478EB
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 06:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfFQEGj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 00:06:39 -0400
Received: from ozlabs.org ([203.11.71.1]:41627 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfFQEGi (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 00:06:38 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45RyMJ6YWDz9sDX; Mon, 17 Jun 2019 14:06:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560744396; bh=0cKzGdt6WGsAZB+3r9paweiXCWroPIbVCKopag+ojKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0EfrHRuzCrzprrirgHeOsXdN2MtYJKGs6jXEhmiug8dsUK12ukgYg32hkFCb32M/
         SEWnO0nlsdQrwLeL95aLHsYI9wNrhfo+dt7avrzQ3v6WFTsS3n8LqE1+R1ZoH1wVOB
         XhRxaQpvwDQ+wOyiTLrg4oBAuxXIPQbr1gLS9PdXzmBOK3h0TTrb8o7c4DwqDiEDij
         BtF6DgIrxDxJ3ODFdTsYKOQVtKq7em0JyemWTaH0hwIzAMfahUUjv2X1YXLbU8b0Hk
         exxEagml3AklSQK/5L6IAQtiDBLPPDNXXL2MENQvKE2dFxXAr28p+NlONIhtySetgU
         yElL5UmUA4eOQ==
Date:   Mon, 17 Jun 2019 14:06:32 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [RFC PATCH v4 6/6] kvmppc: Support reset of secure guest
Message-ID: <20190617040632.jiq73ogxqyccvfjl@oak.ozlabs.ibm.com>
References: <20190528064933.23119-1-bharata@linux.ibm.com>
 <20190528064933.23119-7-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528064933.23119-7-bharata@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, May 28, 2019 at 12:19:33PM +0530, Bharata B Rao wrote:
> Add support for reset of secure guest via a new ioctl KVM_PPC_SVM_OFF.
> This ioctl will be issued by QEMU during reset and in this ioctl,
> we ask UV to terminate the guest via UV_SVM_TERMINATE ucall,
> reinitialize guest's partitioned scoped page tables and release all
> HMM pages of the secure guest.
> 
> After these steps, guest is ready to issue UV_ESM call once again
> to switch to secure mode.

Since you are adding a new KVM ioctl, you need to add a description of
it to Documentation/virtual/kvm/api.txt.

Paul.
