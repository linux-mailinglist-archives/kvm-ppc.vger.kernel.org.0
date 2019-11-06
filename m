Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871E1F0E8E
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 06:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfKFF63 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: from ozlabs.org ([203.11.71.1]:39213 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfKFF63 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 477G6q2hTsz9sPk; Wed,  6 Nov 2019 16:58:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573019907; bh=46gVeJC3dAyUhPqJ+NlvAv/IlXtVW7QrzM+5gy1u8eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HHMCpQKdyTCYf5CoNlipflMhC6MOArs1jnJrZWiyfg3s4UQLqUKCAk7jPXWgC7yAe
         2ZHWBR0YUuPk4zD9tAwQTZtRmIHc6dtWaGsNGXGnFOQb4wPirBZTrUnUJ10HC1H6o4
         nKZ2OIFN6jI+nxz9U3H4gPsliLqud8BLRcuEiuU8p27O16C8ueKYVMK8CrQ0mQpXkI
         RqlylrOVP7xlVWlS+RF2ye0g8YibvqaO//2XNQ+sFD+Nog0DruyN7vZhjolrqeEk7U
         UwAK2UJuF/fbivVZliFKXO0XJoZ7dQ3jGSr/3eUllAfeGb27dVreStB8ngrbt4GmI/
         rzuV5+OKu7pAw==
Date:   Wed, 6 Nov 2019 15:33:29 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 1/8] mm: ksm: Export ksm_madvise()
Message-ID: <20191106043329.GB12069@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-2-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:53AM +0530, Bharata B Rao wrote:
> KVM PPC module needs ksm_madvise() for supporting secure guests.
> Guest pages that become secure are represented as device private
> pages in the host. Such pages shouldn't participate in KSM merging.

If we don't do the ksm_madvise call, then as far as I can tell, it
should all still work correctly, but we might have KSM pulling pages
in unnecessarily, causing a reduction in performance.  Is that right?

> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
