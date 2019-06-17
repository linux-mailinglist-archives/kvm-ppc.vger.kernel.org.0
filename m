Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD82479B8
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 07:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbfFQFi7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 01:38:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57109 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfFQFi7 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 01:38:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S0Ps3h6Wz9sBr; Mon, 17 Jun 2019 15:38:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560749937; bh=dZLUB0K5zrKTMsdEtdgkBMLfWZFYjrdP1VEZ//9dUfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eD7AWdyTBgymNpigRRjlwERLwtz6+5IChPlo6tHPrxOURmrv98db8J5lCApb6YzII
         UYl3AnywVl7MTAtOij4HF01ADdMY35yKXfvU6/8pMBTb8gXHGOf2mYLRm8HegSgQck
         qMHlW+/lnMQZCsSG75fQDuNcf17Izc3mLHUjShvRcjQ2B2GPTvPP19iznAPVzabihg
         /hQ1PUtN7jZqTYHlqJD5VQPAMRnZfXx0s4pAnM1c7kYei4KBoafU7PPaQGCcAiPqj/
         4CS602Ceg11qIljPAT9rsVnOXFdPBHH+ViwSOKfXAKsCJo0vHeZSFT89Vt2BkuW+p2
         fg4dE4xYnjfyg==
Date:   Mon, 17 Jun 2019 15:37:56 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v4 3/6] kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE
 hcalls
Message-ID: <20190617053756.z4disbs5vncxneqj@oak.ozlabs.ibm.com>
References: <20190528064933.23119-1-bharata@linux.ibm.com>
 <20190528064933.23119-4-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528064933.23119-4-bharata@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, May 28, 2019 at 12:19:30PM +0530, Bharata B Rao wrote:
> H_SVM_INIT_START: Initiate securing a VM
> H_SVM_INIT_DONE: Conclude securing a VM
> 
> As part of H_SVM_INIT_START register all existing memslots with the UV.
> H_SVM_INIT_DONE call by UV informs HV that transition of the guest
> to secure mode is complete.

It is worth mentioning here that setting any of the flag bits in
kvm->arch.secure_guest will cause the assembly code that enters the
guest to call the UV_RETURN ucall instead of trying to enter the guest
directly.  That's not necessarily obvious to the reader as this patch
doesn't touch that assembly code.

Apart from that this patch looks fine.

> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
