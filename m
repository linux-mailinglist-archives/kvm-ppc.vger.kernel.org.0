Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18E728E752
	for <lists+kvm-ppc@lfdr.de>; Wed, 14 Oct 2020 21:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390681AbgJNTal (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Oct 2020 15:30:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33850 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390721AbgJNTal (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 14 Oct 2020 15:30:41 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EJSYBl061274;
        Wed, 14 Oct 2020 15:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 message-id : reply-to : references : mime-version : content-type :
 in-reply-to : subject; s=pp1;
 bh=dqPI9ss08CvFwEtyDf9xVOAC51gIZkX8tKGhguVx19Q=;
 b=LyPIFWC4c8jUj00uiH+JfiiPU34EjHy3CtmMP3AS8ZKQ6tj4bQEwIVvt91hiDWJlpB0Z
 LcP9ARUy/VKoCVAvvdHazPm/eqm7DGoI1LwqkGoyJnp3W+YGbJyWjsRGypGzeKMFTISe
 MDAW1bSXS6iS0iiNoIWJKrwBXEfhXIEPRcPyXF09sQEUCFwK5gpzt6y+79tZM99nKauW
 sha6bVHws56JkUtZ1b5FbtBxb1MgsDm8ftLYjogrhYpWB7CdQl5s1lTqtQ0/lAcQqQAB
 et6dpjTCz85Iu4V5gUJ/iFyvYOOjbXJsJb4yntqGbUyEIvaJHrx/IdiCjGD3QwJkEdSY Xw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3467h081kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 15:30:31 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09EJMbAJ009580;
        Wed, 14 Oct 2020 19:30:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3434k84fxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 19:30:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09EJURJ723331100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 19:30:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03F9F5208F;
        Wed, 14 Oct 2020 19:30:27 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.85.191.234])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 911215206D;
        Wed, 14 Oct 2020 19:30:25 +0000 (GMT)
Date:   Wed, 14 Oct 2020 12:30:22 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        farosas@linux.ibm.com, bharata@linux.ibm.com
Message-ID: <20201014193022.GA3853@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1602487663-7321-1-git-send-email-linuxram@us.ibm.com>
 <20201014063117.GA26161@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014063117.GA26161@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: RE: [RFC v1 0/2] Plumbing to support multiple secure memory backends.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_11:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 spamscore=0 mlxlogscore=737 lowpriorityscore=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140131
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Oct 14, 2020 at 07:31:17AM +0100, Christoph Hellwig wrote:
> Please don't add an abstraction without a second implementation.
> Once we have the implementation we can consider the tradeoffs.  E.g.
> if expensive indirect function calls are really needed vs simple
> branches.

Ok. Not planning on upstreaming these patches till we have atleast
another backend.

-- 
Ram Pai
