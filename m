Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D86E127
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Jul 2019 08:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfGSGqn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Jul 2019 02:46:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfGSGqn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Jul 2019 02:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dFnx5TzMMcoSpuOVSBkt3bk6kgdNjnFBeNAo17jg5Wk=; b=YPaurXaTajlIneAubMagzsXcC
        s7lRHW6bMmRz5vJoILwjx09X/rG2EhotoYUCEBkPgAPRvep7T9EL8rE9YqZx+lJqfB8dIDW6sgb/f
        5ekxC+GX1RAI38SYBVesXcaEU28iwSanRRpEj/Mj05pSBUI/SgcGybCGhG5k0jsC+sqHbDva5YziK
        mxIe/MvYIGBGZ1jnh1UCzMiQK0WxQFTvo5gFiJu5VkmN0vpIF61rDTSu940GxT4YvZ0Ag8KdzjBt9
        fHnRvSoZHZKlymeW/sRI+JzKkOFfxcda4Fh/aTFGeFCY27ywJsi/kGHel8I3FcBNjtHaD6m2WGCGJ
        +rqfCRqZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hoMfB-0007eC-Mp; Fri, 19 Jul 2019 06:46:41 +0000
Date:   Thu, 18 Jul 2019 23:46:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>,
        linux-mm@kvack.org, jglisse@redhat.com,
        janani <janani@linux.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        paulus@au1.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 1/7] kvmppc: HMM backend driver to manage pages of
 secure guest
Message-ID: <20190719064641.GA29238@infradead.org>
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-2-bharata@linux.ibm.com>
 <29e536f225036d2a93e653c56a961fcb@linux.vnet.ibm.com>
 <20190710134734.GB2873@ziepe.ca>
 <20190711050848.GB12321@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711050848.GB12321@in.ibm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 11, 2019 at 10:38:48AM +0530, Bharata B Rao wrote:
> Hmmm... I still find it in upstream, guess it will be removed soon?
> 
> I find the below commit in mmotm.

Please take a look at the latest hmm code in mainline, there have
also been other significant changes as well.
