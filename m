Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD88F0E8F
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 06:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfKFF63 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: from ozlabs.org ([203.11.71.1]:49563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfKFF63 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 477G6q1YXnz9sP6; Wed,  6 Nov 2019 16:58:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573019907; bh=fe1cfYqlG7NpLDENgEEgJGCJ15l6iPBAhlJyBRCiARo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VHiP8nxhMyffu/D9d9yF1JnkErmzswDreT+8f+fPbuQgyBQSZ3CZzopDPCERkENrd
         FzxnwBZPsu9KtkRYrsl0FmjxNEw5p0Xba9Q+qSsA62WPZJORrz9ZJuM9fej42+ImA5
         0Wi7JoXEqENFNgM80xi0pE3fhr+UAtsAFybft4Fn5TduNkcT4cWbQX19lxfCu1weWW
         2Vu2Dvk3h/rMEU9P/LMRsIJD5Jgqqre+AjPWu4uNWkPvAeoYrA4Y2lCELjxObrT5lW
         mCl7MKn6N2GfPUKj9sWSHT4jfak3uCfqWi3YOL32lNx7hb+cuTIy51WRubgzc8p10a
         zufv0lF3FxTUw==
Date:   Wed, 6 Nov 2019 16:58:23 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 4/8] KVM: PPC: Radix changes for secure guest
Message-ID: <20191106055823.GE12069@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-5-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-5-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:56AM +0530, Bharata B Rao wrote:
> - After the guest becomes secure, when we handle a page fault of a page
>   belonging to SVM in HV, send that page to UV via UV_PAGE_IN.
> - Whenever a page is unmapped on the HV side, inform UV via UV_PAGE_INVAL.
> - Ensure all those routines that walk the secondary page tables of
>   the guest don't do so in case of secure VM. For secure guest, the
>   active secondary page tables are in secure memory and the secondary
>   page tables in HV are freed when guest becomes secure.

Why do we free the page tables?  Just to save a little memory?  It
feels like it would make things more fragile.

Also, I don't see where the freeing gets done in this patch.

Paul.
