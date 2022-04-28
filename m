Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8D5139FB
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Apr 2022 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349910AbiD1QlK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Apr 2022 12:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiD1QlJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Apr 2022 12:41:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAD6ABF42
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Apr 2022 09:37:54 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SFVUiR015763;
        Thu, 28 Apr 2022 16:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=s7BRzal7CpLHfjJ4W0K08+aUhGjOLfGQ3AtdkysoDbQ=;
 b=Ob1O2byc+T8m1MN3I75bCtL8xfE46DO9NKQajM6F+IikHt15XyraskrB1DnFwMZE2HK6
 uapsWnMOaJ5yHzRVIDZAmp9R5y6EdZjR86L9KyfBjQ+DANGgh1SB6tGkpLZ/DNgBJd9u
 IE/K1m94qgAyZ5CXElklrIA+rsuf8Mjp4y2iKP5uukD2QojYbxcXqGCxiufpaHzVkciv
 b+wgKomZcFCsnUWYMbO2JHqLFFJVu8aMPTAYSB0IX+S9oe3f0JjBY3igVtOOskaXaoh/
 t57a12JILf+GmIl+so7kFfzgfKCRkNcScgmMrTOnCykwd6LeP3hxB83rmmIRpLZmvoOH Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqsyhg0aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 16:37:44 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23SGUR35004440;
        Thu, 28 Apr 2022 16:37:44 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqsyhg0ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 16:37:44 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23SGWagp020458;
        Thu, 28 Apr 2022 16:37:43 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3fm93b56cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 16:37:43 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23SGbg8K30278074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 16:37:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B12578060;
        Thu, 28 Apr 2022 16:37:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E7A87805E;
        Thu, 28 Apr 2022 16:37:41 +0000 (GMT)
Received: from localhost (unknown [9.65.200.87])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 28 Apr 2022 16:37:41 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Initialize AMOR in nested entry
In-Reply-To: <1651118922.7qh15cf4pc.astroid@bobo.none>
References: <20220425142151.1495142-1-farosas@linux.ibm.com>
 <1651118922.7qh15cf4pc.astroid@bobo.none>
Date:   Thu, 28 Apr 2022 13:37:38 -0300
Message-ID: <87czh1qi3x.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7yfjH7NOFhJ_vManKGWojMhAyhxCKYb5
X-Proofpoint-ORIG-GUID: MKXeQAmHwK-j0CzVUYdGlo-uAMpT-Mxb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_02,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=616 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Excerpts from Fabiano Rosas's message of April 26, 2022 12:21 am:
>> The hypervisor always sets AMOR to ~0, but let's ensure we're not
>> passing stale values around.
>> 
>
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>
> Looks like our L0 doesn't do anything with hvregs.amor ?

It doesn't. And if the HV ever starts clearing bits from AMOR, then we
would need to change any kernel code that writes and reads from AMR (
such as the KUAP) to take into consideration that we might read a
different value from what we wrote.
